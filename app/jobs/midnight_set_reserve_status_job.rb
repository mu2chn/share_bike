class MidnightSetReserveStatusJob < ApplicationJob
  queue_as :default

  # Early Morning you should exec
  def perform(*args)
    end_rental
    reward
  end

  def end_rental
    #実行時から一日と３時間以内
    yesterday =  Time.now.yesterday.beginning_of_day..Time.now.yesterday.end_of_day
    reservations = TouristBike.where(status: 'default').where(end_datetime: yesterday)
    reservations.each do |res|
      if res.tourist_id.present?
        #noinspection RubyResolve
        #NotifyUs
        res.status_freeze!
        DbLogger.dump("res:#{res.id} statusがdefaultかstartに変更されていません. メールが来てないか確認して下さい。")
        #noinspection RubyResolve
        res.status_unused!
      end
    end

    reservations = TouristBike.where(status: 'start').where(end_datetime: yesterday)
    reservations.each do |res|
      #noinspection RubyResolve
      #NotifyUs
      res.status_freeze!
      DbLogger.dump("res:#{res.id} statusがstartからendに変更されていません. メールが来てないか確認して下さい。")
    end
  end

  def reward
    days_ago_3 = (Time.now-3.days).beginning_of_day..(Time.now-3.days).end_of_day
    reservations = TouristBike.where(end_datetime: days_ago_3).where(status: 'end').where.not(tourist_id: nil)
    reservations.each do |res|
      dump = res.dump_reward
      if dump.nil?
        #NotifyUs
        DbLogger.dump("res:#{res.id} cannot dump reward. 詳細を確認して下さい。")
      end
    end
  end
end
