class NoonSetReserveStatusJob < ApplicationJob
  queue_as :default

  def perform(*args)
    review_mail
  end

  def review_mail
    reservations = TouristBike.where(end_datetime: (Time.now-2.days)..(Time.now-1.days)).where.not(tourist_id: nil).where.not(status: 'freeze')
    reservations.each do |res|
      ReviewMailer.tourist_review(res).deliver_later
    end
  end
end
