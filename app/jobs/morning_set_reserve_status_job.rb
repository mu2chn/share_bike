class MorningSetReserveStatusJob < ApplicationJob
  queue_as :default

  # Morning you should exec
  def perform(*args)
    start_notify
  end

  # status START_RENTAL
  def start_notify
    reservations = TouristBike.where(start_datetime: Time.now..(Time.now+15.hours)).where.not(tourist_id: nil)
    reservations.each do |res|
      NotificationMailer.start_rental_confirm_to_user(res).deliver_later
    end
  end
end
