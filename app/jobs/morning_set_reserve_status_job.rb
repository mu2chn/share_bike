class MorningSetReserveStatusJob < ApplicationJob
  queue_as :default

  # Morning you should exec
  def perform(*args)
    start_notify
  end

  # status START_RENTAL
  def start_notify
    reservations = TouristBike.where(status: START_RENTAL).where.not(tourist_id: nil)
    reservations.each do |res|
      if after(res.start_datetime, 0)
        NotificationMailer.start_rental_confirm_to_user(res).deliver_later
      end
    end
  end
end
