module PaymentsService


  include ApplicationService
  require 'paypal-checkout-sdk'
  include PayPalCheckoutSdk::Orders


  def pay_execute(json)
    client = Payment.init_client
    transaction = Transaction.create(
        order_id: json["orderID"],
        authorization_id: json["authorizationID"],
    )

    order = transaction.order_detail(2700, "JPY", client)
    if order[0] == 1
      raise CustomException::ApiCustomJsonException::new({
           msg: I18n.t('flash.payment.pay.fail.not_enough'),
           payment: false
       })
    end
    tourist = transaction.tourist

    reserve_tourist_id = order[1][:result][:purchase_units][0][:reference_id]
    reserve_id = /^\d+/.match(reserve_tourist_id)[0].to_i
    reservation = TouristBike.find(reserve_id)

    #noinspection RubyResolve
    if reservation.void
      msg = I18n.t('flash.payment.pay.fail.invalid_resv')
    elsif !tourist.authenticated
      msg = I18n.t('flash.payment.pay.fail.not_authenticated')
    elsif reservation.end_datetime < Time.now
      msg = I18n.t('flash.payment.pay.fail.already_end')
    elsif not reservation.status_default?
      msg = I18n.t('flash.payment.pay.fail.not_default')
    elsif reservation.tourist_id.present?
      msg = I18n.t('flash.payment.pay.fail.already_reserved')
    else
      auth = transaction.capture_for_ticket({amount: {value: "700", currency_code: "JPY"}}, client)
      if auth[0] == 0
        if reservation.tourist_id.present?
          msg = I18n.t('flash.payment.pay.fail.already_reserved')
          transaction.refund_before_ride(client)
        else
          reservation.update_attributes(tourist_id: tourist.id, transaction_id: transaction.id)
          NotificationMailer.send_confirm_to_user(tourist, reservation).deliver_later
          return {payment: true}
        end
      else
        msg = I18n.t('flash.payment.pay.fail.exec')
      end
    end
    transaction.void_all_of_order(client)
    raise CustomException::ApiCustomJsonException::new({
       msg: msg,
       payment: false
    })
  end
end