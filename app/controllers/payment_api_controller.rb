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

    transaction = Transaction.create(
        {void: true, order_id: json["orderID"], authorization_id: json["authorizationID"]})

    order = transaction.order_detail(client, 700, "JPY")
    @tourist = transaction.tourist

    reserve_tourist_id = order[1][:result][:purchase_units][0][:reference_id]
    reserve_id = /^\d+/.match(reserve_tourist_id)[0].to_i
    @reserve = TouristBike.find(reserve_id)

    if @reserve.void
      msg = "voidです"
      render json: {payment: false, msg: msg}
    elsif !@tourist.authenticated
      msg = "メール認証されていません"
      render json: {payment: false, msg: msg}
    elsif @reserve.tourist_id.present?
      msg = "すでに予約されています"
      render json: {payment: false, msg: msg}
    else
      auth = transaction.authorization(client)
      if auth[0] == 0
        transaction.update_attributes(void: false)
        if @reserve.tourist_id.present?
          msg = "すでに予約されています"
          transaction.refund_order(client)
          render json: {payment: false, msg: msg}
        else
          @reserve.update_attributes(tourist_id: @tourist.id, transaction_id: transaction.id)
          NotificationMailer.send_confirm_to_user(@tourist, @reserve).deliver_later
          render json: {payment: true}
        end
      else
        msg = "支払いに失敗しました"
        render json: {payment: false, msg: msg}
      end
    end
  end

  def unpaid

  end


end
