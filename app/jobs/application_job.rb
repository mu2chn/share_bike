class ApplicationJob < ActiveJob::Base
  # ONLY FOLLOWED BY TIMELINE ( PROBLEM IS IGNORED! )
  DEFAULT_RENTAL = 0
  SOON_RENTAL = 10
  START_RENTAL = 20
  END_RENTAL = 30
  REVIEW_RENTAL = 40

  # during日後
  def after(day, during)
    expire = Date.current + during.day
    expire.beginning_of_day <= day and day <= expire.end_of_day
  end
end
