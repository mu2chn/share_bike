module BikesService
  include ApplicationService

  def create_bike(params, user)
    bike = Bike.new(params)
    bike.user_id = user.id
    if bike.save
      bike
    else
      raise CustomException::NamedException::new(I18n.t('flash.bike.create.fail.register'))
    end
  end

  def update_bike(bike, params, user)
    if bike.user_id == user.id
      if bike.update_attributes(params)
        bike
      else
        raise CustomException::NamedException::new(I18n.t('flash.bike.update.fail.exec'))
      end
    else
      raise CustomException::NamedException::new(I18n.t('flash.bike.update.fail.permission'))
    end
  end

  def make_month
    pre_month = (Date.today...Date.tomorrow.end_of_month).to_a
    next_month =  (Date.tomorrow.end_of_month..Date.today.next_month).to_a
    if !pre_month
      days = next_month
    elsif !next_month
      days = pre_month
    else
      days = pre_month + next_month
    end
    days[0, 9].map do |date|
      [ "#{date.month}月#{date.day}日（#{[ "日", "月", "火", "水", "木", "金", "土"][date.wday]}）", date.strftime("%Y/%m/%d")]
    end.to_a
  end

  def tutorial_index(user)
    if user.nil?
      return nil
    end
    user.update_attribute(:tutorial,
                          tutorial(user.tutorial, 0, I18n.t('flash.bike.tutorial.index')))
  end

  def tutorial_show(user)
    if user.nil?
      return nil
    end
    user.update_attribute(:tutorial,
                          tutorial(user.tutorial, 1, I18n.t('flash.bike.tutorial.show')))
  end
end