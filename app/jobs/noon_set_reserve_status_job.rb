class NoonSetReserveStatusJob < ApplicationJob
  queue_as :default

  def perform(*args)
    review_mail
    soon_rental
  end

  def review_mail
    reservations = TouristBike.where(status: END_RENTAL).where.not(tourist_id: nil)
    reservations.each do |res|
      if after(res.day, -1)
        ReviewMailer.tourist_review(res).deliver_later
      end
    end
  end

  def soon_rental
    reservations = TouristBike.where(status: DEFAULT_RENTAL).where.not(tourist_id: nil)
    reservations.each do |res|
      if after(res.day, 2)
        NotificationMailer.soon_rental_confirm_to_user(res).deliver_later
      end
    end
  end
end
