class MidnightSetReserveStatusJob < ApplicationJob
  queue_as :default

  # Early Morning you should exec
  def perform(*args)
    end_review
    end_rental
    start_rental
  end

  # status START_RENTAL
  def start_rental
    reservations = TouristBike.where(status: DEFAULT_RENTAL).where.not(tourist_id: nil)
    reservations.each do |res|
      if after(res.start_datetime, 0)
        res.update_attributes(status: START_RENTAL)
      end
    end
  end

  def end_rental
    reservations = TouristBike.where(status: START_RENTAL).where.not(tourist_id: nil)
    reservations.each do |res|
      if after(res.start_datetime, -1)
        res.update_attributes(status: END_RENTAL)
      end
    end
  end

  def end_review
    reservations = TouristBike.where(status: END_RENTAL).where.not(tourist_id: nil)
    reservations.each do |res|
      if after(res.start_datetime, -2)
        res.update_attributes(status: REVIEW_RENTAL)
      end
    end
  end
end
