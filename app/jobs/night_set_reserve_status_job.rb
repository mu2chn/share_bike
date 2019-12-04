class NightSetReserveStatusJob < ApplicationJob
  queue_as :default

    # Night you should exec
  def perform(*args)
    tomorrow_rental
  end

  # status START_RENTAL
  def tomorrow_rental
    reservations = TouristBike.where(start_datetime: (Time.now+1.days)..(Time.now+2.days)).where.not(tourist_id: nil)
    reservations.each do |res|
      if after(res.start_datetime, 1)
        NotificationMailer.tomorrow_rental_confirm_to_user(res).deliver_later
      end
    end
  end
end
