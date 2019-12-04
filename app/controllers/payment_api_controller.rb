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
        order_id: json["orderID"],
        authorization_id: json["authorizationID"],
    )

    order = transaction.order_detail(2700, "JPY", client)
    if order[0] == 1
      render json: {payment: false, msg: "金額が不正です"}, status: :unprocessable_entity
      return nil
    end
    @tourist = transaction.tourist

    reserve_tourist_id = order[1][:result][:purchase_units][0][:reference_id]
    reserve_id = /^\d+/.match(reserve_tourist_id)[0].to_i
    @reserve = TouristBike.find(reserve_id)

    if @reserve.void
      msg = "無効な予約です"
    elsif !@tourist.authenticated
      msg = "メール認証されていません"
    elsif @reserve.end_datetime < Time.now
      msg = "すでに終了しています"
    elsif @reserve.tourist_id.present?
      msg = "すでに予約されています"
    else
      auth = transaction.capture_for_ticket({amount: {value: "700", currency_code: "JPY"}}, client)
      if auth[0] == 0
        if @reserve.tourist_id.present?
          msg = "すでに予約されています"
          transaction.refund_before_ride(client)
        else
          @reserve.update_attributes(tourist_id: @tourist.id, transaction_id: transaction.id)
          NotificationMailer.send_confirm_to_user(@tourist, @reserve).deliver_later
          render json: {payment: true}
          return nil
        end
      else
        msg = "支払いに失敗しました"
      end
    end
    transaction.void_all_of_order(client)
    render json: {payment: false, msg: msg}, status: :unprocessable_entity
  end

  def unpaid

  end


end
