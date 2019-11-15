class TouristBike < ApplicationRecord
  belongs_to :bike
  belongs_to :tourist, optional: true

  #########################
  # admin methods
  #########################

  def cancel
    if self.tourist_id.present?
      trans = Transaction.find(self.transaction_id)
      status = trans.refund_order(Payment.init_client)
      if status[0] == 0
          trans.update_attributes(
            void: true,
            refunded: true
          )
          self.update_attributes(
            transaction_id: nil,
            tourist_id: nil
          )
          return status[1]
      else
          return status[1]
      end
    end
    return "no record"
  end
end
