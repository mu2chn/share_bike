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
        self.update_attributes(valid_ticket: false )
      elsif amount != expected_amount.to_i
        self.update_attributes(valid_ticket: false )
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
      ticket_price = capture[1][:result][:amount][:value].to_i
      self.update_attributes(
          capture_ticket: capture_id,
          valid_ticket: true,
          ticket_amount: ticket_price
      )
      return [0, capture[1]]
    end
    [1, capture[1]]
  end

  def refund_before_ride(client=Payment.init_client)
    if self.refunded
      return [2, "already refunded"]
    end
    refund = Payment.refund(self.capture_ticket, client)
    if refund[0] == 0
      self.update_attributes(
          refund_ticket: refund[1][:result][:id],
          valid_ticket: false,
          voided_deposit: true
      )
      refund
    else
      refund
    end
  end

  def void_all_of_order(client=Payment.init_client)
    unless self.voided_all
      void_response = Payment.void(self.authorization_id)
      if void_response[0] == 0
        self.update_attributes(
            valid_ticket: false ,
            voided_all: true
        )
      end
      void_response
    end
    [1, "already voided or captured"]
  end

  # after 3 days
  def capture_for_deposit(capture_body, client=Payment.init_client)
    re_auth = Payment.re_auth(self.authorization_id, client)
    if re_auth[0] == 1
      # return re_auth
    else
      re_auth_id = re_auth[1][:result][:id]
      self.update_attributes(
          re_authorization_id: re_auth_id
      )
    end
    re_auth_id ||= self.authorization_id #TODO fix before rerease
    unless capture_body.dig(:amount, :currency_code) == self.currency or capture_body.dig(:amount, :currency_code).nil?
      return [1, "currency_code invalid"]
    end
    capture = Payment.capture(re_auth_id, capture_body, client)
    # if (not self.voided_deposit) and (self.capture_deposit.nil?)
    if capture[0] == 0
      capture_id = capture[1][:result][:id]
      deposit_price = capture[1][:result][:amount][:value].to_i
      self.update_attributes(
          capture_deposit: capture_id,
          deposit_amount: deposit_price
      )
      return [0, capture[1]]
    end
    [1, capture[1]]
  end

  def refund_for_deposit(client=Payment.init_client)
    if self.capture_deposit.present?
      refund = Payment.refund(self.capture_deposit, client)
      if refund[0] == 0
        self.update_attributes(refund_deposit: refund[1][:result][:id])
      end
      return refund
    end
    [1, "didnt capture deposit"]
  end

  def void_deposit(client=Payment.init_client)
    void_detail = Payment.void(self.authorization_id) #TODO makes err?
    if void_detail[0] == 0
      self.update_attributes(voided_deposit: true)
      return void_detail
    end
    void_detail
  end
end
