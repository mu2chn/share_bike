class Transaction < ApplicationRecord
  belongs_to :tourist, optional: true

  # amount and currency is valid?
  def order_detail(expected_amount, expected_currency, client=Payment.init_client)
    order_detail = Payment.order(self.order_id, client)
    if order_detail[0] == 0
      detail  = order_detail[1]
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
      if currency != expected_currency
        self.update_attributes(void: true)
      elsif amount != expected_amount.to_i
        self.update_attributes(void: true)
      else
        return order_detail
      end
    end
    [1, order_detail[1]]
  end

  def show_order(client=Payment.init_client)
    Payment.order(self.order_id, client)
  end

  def capture_for_ticket(capture_body, client=Payment.init_client)
    unless capture_body.dig(:amount, :currency_code) == self.currency or capture_body.dig(:amount, :currency_code).nil?
      return [1, "currency_code invalid"]
    end
    capture = Payment.capture(self.authorization_id, capture_body, client)
    if capture[0] == 0
      capture_id = capture[1][:result][:id]
      update_amount = self.amount - capture[1][:result][:amount][:value].to_i
      self.update_attributes(
          capture_id: capture_id,
          void: false,
          amount: update_amount
      )
      return [0, capture[1]]
    end
    [1, capture[1]]
  end

  def refund_order(client=Payment.init_client)
    if self.refunded
      return [2, "already refunded"]
    end
    refund = Payment.refund(self.capture_id, client)
    if refund[0] == 0
      self.update_attributes(
          refunded: true,
          void: true
      )
      refund
    else
      refund
    end
  end

  def void_order(client=Payment.init_client)
    unless self.voided && self.capture_id.nil?
      void_response = Payment.void(self.authorization_id)
      if void_response[0] == 0
        self.update_attributes(
            voided: true,
            void: true
        )
      end
      void_response
    end
    [1, "already voided or captured"]
  end
end
