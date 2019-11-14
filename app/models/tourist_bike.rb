class TouristBike < ApplicationRecord
  belongs_to :bike
  belongs_to :tourist, optional: true


  #########################
  # admin methods
  #########################

  def cancel
      status = Payment.refund(self.capture_id)
      if status[0] == 0
          self.update_attributes(
              capture_id: nil,
              order_id: nil,
              tourist_id: nil,
              authorization_id: nil,
              amount: nil,
              paid_date: nil,
              status: 0
          )
          return status[1][:result]
      else
          return status[1][:result]
      end
  end
end
