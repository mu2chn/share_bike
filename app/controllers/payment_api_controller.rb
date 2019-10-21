class PaymentApiController < ApplicationController
  skip_before_action :verify_authenticity_token

  require 'paypal-checkout-sdk'
  include PayPalCheckoutSdk::Orders

  # require 'paypal-sdk-rest'
  # include PayPal::SDK::REST
  # include PayPal::SDK::Core::Logging

  def test
    NotificationMailer.send_confirm_to_user(Tourist.find_by(email: "face93632@eay.jp")).deliver_later
    render about_path
  end

  def check
    client_id = "AbmTHlJhDD2_U9v4JbjXULVdrAcAAFJqb1ZH-ZbpICzZuYWjaMwiQsOoXCytKCcqK2BfP31zjMTpC7sT"
    client_secret = "EOo9mHVWT1T4fubdtQErBcgEXIbd3XTEiCrKjr9l3CwNzDW59PgYlcNP7dEp1DSvYyaAYkXwPexFwZ0_"
    environment = PayPal::SandboxEnvironment.new(client_id, client_secret)
    client = PayPal::PayPalHttpClient.new(environment)
    json = JSON.parse(request.body.read)
    order = PayPalCheckoutSdk::Orders::OrdersGetRequest::new(json["orderID"])
    order_detail = client.execute(order)
    currency = order_detail[:result][:purchase_units][0][:amount][:currency_code]
    amount = order_detail[:result][:purchase_units][0][:amount][:value].to_i
    reserve_tourist_id = order_detail[:result][:purchase_units][0][:reference_id]

    reserve_id = /^\d+/.match(reserve_tourist_id)[0].to_i
    tourist_id = /\d+$/.match(reserve_tourist_id)[0].to_i

    @reserve = TouristBike.find(reserve_id)
    @tourist = Tourist.find(tourist_id)

    request = PayPalCheckoutSdk::Payments::AuthorizationsCaptureRequest::new(json["authorizationID"])
    request.prefer("return=representation")
    request.request_body({})
    response_auth = client.execute(request)
    capture_id = response_auth[:result][:id]

    if not @reserve.tourist_id.nil? and not @reserve.order_id.nil?
      p "すでに予約されています"
      refund = PayPalCheckoutSdk::Payments::CapturesRefundRequest::new(capture_id)
      client.execute(refund)
    elsif amount < 700 or currency != "JPY"
      p "金額が不正です"
      refund = PayPalCheckoutSdk::Payments::CapturesRefundRequest::new(capture_id)
      client.execute(refund)
    else
      @reserve.order_id = json["orderID"]
      @reserve.tourist_id = tourist_id
      @reserve.amount = amount
      @reserve.paid_date = DateTime.now
      @reserve.authorization_id = json["authorizationID"]
      @reserve.capture_id = capture_id

      if @reserve.save!
        flash[:success] = "予約が完了しました"
        NotificationMailer.payment_confirm_to_user(@tourist, @reserve).deliver_later
        redirect_to t_reserve_path
      else
        flash[:error] = "予約に失敗しました"
      end
    end
  end

  def unpaid

  end


end
