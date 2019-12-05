class MidnightSetReserveStatusJob < ApplicationJob
  queue_as :default

  # Early Morning you should exec
  def perform(*args)
    end_rental
  end

  def end_rental
    #実行時から一日と３時間以内
    reservations = TouristBike.where(status: 'default').where(end_datetime: (Time.now-1.days-3.hours)..Time.now)
    reservations.each do |res|
      if res.tourist_id.present?
        #noinspection RubyResolve
        res.status_end!
      else
        #noinspection RubyResolve
        res.status_unused!
      end
    end
  end

  def reward
    reservations = TouristBike.where(end_datetime: (Time.now-3.days-3.hours)..(Time.now-2.days)).where(status: 'end').where.not(tourist_id: nil)
    reservations.each do |res|
      dump = res.dump_reward

      if dump.nil?
        #NotifyUs
      end
    end

  end
end
