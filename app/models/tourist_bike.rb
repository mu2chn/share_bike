class TouristBike < ApplicationRecord
  belongs_to :bike
  belongs_to :tourist, optional: true

  #########################
  # admin methods
  #########################

  def cancel
    if self.tourist_id.nil?
      return [1, "no record"]
    elsif self.status >= 20
      return [1, "already rental started"]
    end

    trans = Transaction.find(self.transaction_id)
    status = trans.refund_before_ride(Payment.init_client)
    if status[0] == 0
      self.update_attributes(
          transaction_id: nil,
          tourist_id: nil
      )
    end
    status
  end

  def get_deposit
    if self.tourist_id.nil?
      return [1, "no record"]
    end

    if self.status <= 30 #ApplicationJob.END_RENTAL
      trans = Transaction.find(self.transaction_id)
      status = trans.capture_for_deposit({amount: {value: 2000, currency_code: "JPY"}})
      return status
    end
    [1, "not finished rental"]
  end


  def refund_deposit
    if self.tourist_id.nil?
      return [1, "no record"]
    end

    trans = Transaction.find(self.transaction_id)
    status = trans.refund_for_deposit
  end
end

