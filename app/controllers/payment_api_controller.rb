class PaymentApiController < ApplicationController
  skip_before_action :verify_authenticity_token

  require 'paypal-checkout-sdk'
  include PayPalCheckoutSdk::Orders

  # require 'paypal-sdk-rest'
  # include PayPal::SDK::REST
  # include PayPal::SDK::Core::Logging

  def test
    # NotificationMailer.send_confirm_to_user(Tourist.find_by(email: "face93632@eay.jp")).deliver_later
    # render about_path
  end

  def check
    client = Payment.init_client
    json = JSON.parse(request.body.read)
    order_detail = Payment.order(json["orderID"], client)[1]

    currency = order_detail[:result][:purchase_units][0][:amount][:currency_code]
    amount = order_detail[:result][:purchase_units][0][:amount][:value].to_i
    reserve_tourist_id = order_detail[:result][:purchase_units][0][:reference_id]
    reserve_id = /^\d+/.match(reserve_tourist_id)[0].to_i
    tourist_id = /\d+$/.match(reserve_tourist_id)[0].to_i
    @reserve = TouristBike.find(reserve_id)
    @tourist = Tourist.find(tourist_id)

    response_auth = Payment.auth(json["authorizationID"], client)[1]
    capture_id = response_auth[:result][:id]

    if @reserve.void
      p "voidです"
      Payment.refund(capture_id, client)
    elsif !@tourist.authenticated
      p "メール認証されていません"
      Payment.refund(capture_id, client)
    elsif not @reserve.tourist_id.nil? and not @reserve.order_id.nil?
      p "すでに予約されています"
      Payment.refund(capture_id, client)
      render json: {payment: false}
    elsif amount < 700 or currency != "JPY"
      p "金額が不正です"
      Payment.refund(capture_id, client)
      render json: {payment: false}
    else
      update = @reserve.update_attributes(
          order_id: json["orderID"],
          tourist_id: tourist_id,
          amount: amount,
          paid_date: DateTime.now,
          authorization_id: json["authorizationID"],
          capture_id: capture_id
      )
      if update
        NotificationMailer.send_confirm_to_user(@tourist, @reserve).deliver_later
        render json: {payment: true}
      else
        render json: {payment: false}, status: :unprocessable_entity
      end
    end
  end

  def unpaid

  end


end
