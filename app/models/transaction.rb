class Transaction < ApplicationRecord


  # amount and currency is valid?
  def order_detail(client, expected_amount, expected_currency)
    order_detail = Payment.order(self.order_id, client)
    if order_detail[0] == Payment.SUCCESS
      detail  = order_detail[1]
      currency = detail[:result][:purchase_units][0][:amount][:currency_code]
      amount = detail[:result][:purchase_units][0][:amount][:value].to_i
      reserve_tourist_id = detail[:result][:purchase_units][0][:reference_id]
      tourist_id = /\d+$/.match(reserve_tourist_id)[0].to_i
      self.update_attributes(
              currency: currency,
              amount: amount,
              tourist_id: tourist_id
      )
      if currency != expected_currency
        self.update_attributes(void: true)
      elsif amount != expected_amount.to_i
        self.update_attributes(void: true)
      else
        return [0, order_detail]
      end
    end
    [1, order_detail]
  end

  def authorization(client)
    capture = Payment.auth(self.authorization_id, client)
    if capture[0] == Payment.SUCCESS
      capture_id = capture[:result][:id]
      self.update_attributes(capture_id: capture_id)
      return [0, capture[1]]
    end
    [1, capture[1]]
  end

  def refund_order(client)
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
end
