class Transaction < ApplicationRecord
  belongs_to :tourist, optional: true

  # amount and currency is valid?
  def order_detail(client=Payment.init_client)
    order_detail = Payment.order(self.order_id, client)
    detail  = order_detail
    payer_id = detail[:result][:payer][:payer_id]
    currency = detail[:result][:purchase_units][0][:amount][:currency_code]
    amount = detail[:result][:purchase_units][0][:amount][:value].to_i
    reserve_tourist_id = detail[:result][:purchase_units][0][:reference_id]
    tourist_id = /\d+$/.match(reserve_tourist_id)[0].to_i
    self.update_attributes(
            currency: currency,
            amount: amount,
            tourist_id: tourist_id,
            payer_id: payer_id
    )
    order_detail
  end

  def show_order(client=Payment.init_client)
    Payment.order(self.order_id, client)
  end

  def capture_for_ticket(capture_body, client=Payment.init_client)
    unless capture_body.dig(:amount, :currency_code) == self.currency or capture_body.dig(:amount, :currency_code).nil?
      raise CustomException::PaymentErr::new("currency code invalid.")
    end
    capture = Payment.capture(self.authorization_id, capture_body, client)
    capture_id = capture[:result][:id]
    ticket_price = capture[:result][:amount][:value].to_i
    self.update_attributes(
        capture_ticket: capture_id,
        valid_ticket: true,
        ticket_amount: ticket_price
    )
    capture
  end

  def refund_before_ride(client=Payment.init_client)
    if self.refund_ticket
      raise CustomException::PaymentErr::new("already refunded.")
    end
    refund = Payment.refund(self.capture_ticket, client)
    self.update_attributes(
        refund_ticket: refund[:result][:id],
        valid_ticket: false,
        voided_deposit: true
    )
    refund
  end

  def void_all_of_order(client=Payment.init_client)
    if self.voided_all
      raise CustomException::PaymentErr::new("already voided or captured")
    else
      void_response = Payment.void(self.authorization_id)
      self.update_attributes(
          valid_ticket: false,
          voided_all: true
      )
      void_response
    end
  end

  # after 3 days
  def capture_for_deposit(capture_body, client=Payment.init_client)
    begin
      re_auth = Payment.re_auth(self.authorization_id, client)
      re_auth_id = re_auth[:result][:id]
      self.update_attributes(
          re_authorization_id: re_auth_id
      )
    end

    re_auth_id ||= self.authorization_id #TODO fix before rerease
    unless capture_body.dig(:amount, :currency_code) == self.currency or capture_body.dig(:amount, :currency_code).nil?
      raise CustomException::PaymentErr::new("currency_code invalid")
    end
    capture = Payment.capture(re_auth_id, capture_body, client)
    capture_id = capture[:result][:id]
    deposit_price = capture[:result][:amount][:value].to_i
    self.update_attributes(
        capture_deposit: capture_id,
        deposit_amount: deposit_price
    )
    capture
  end

  def refund_for_deposit(client=Payment.init_client)
    if self.capture_deposit.present?
      refund = Payment.refund(self.capture_deposit, client)
      self.update_attributes(refund_deposit: refund[:result][:id])
      refund
    else
      raise CustomException::PaymentErr::new("didnt capture deposit")
    end
  end

  def void_deposit(client=Payment.init_client)
    void_detail = Payment.void(self.authorization_id) #TODO makes err?
    self.update_attributes(voided_deposit: true)
    void_detail
  end
end
