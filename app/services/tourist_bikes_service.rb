module TouristBikesService
  include ApplicationService

  def create_reserve(reservation, user)
    if reservation.bike_id.nil?
      raise CustomException::NamedException::new(I18n.t('flash.reservation.create.fail.unselected'))
    elsif !user.authenticated
      raise CustomException::NamedException::new(I18n.t('flash.reservation.create.fail.not_authenticated'))
    elsif Bike.find(reservation.bike_id.to_i).user_id == user.id
      if reservation.start_datetime.nil?
        raise CustomException::NamedException::new(I18n.t('flash.reservation.create.fail.no_date'))
      elsif reservation.start_datetime + 10.minutes > reservation.end_datetime
        raise CustomException::NamedException::new(I18n.t('flash.reservation.create.fail.reversed'))
      elsif reservation.start_datetime <= Time.now + 30.minutes
        raise CustomException::NamedException::new(I18n.t('flash.reservation.create.fail.too_late'))
      elsif reservation.start_datetime > Date.today.since(2.months)
        raise CustomException::NamedException::new(I18n.t('flash.reservation.create.fail.too_early'))
      elsif !TouristBike.where(bike_id: reservation.bike_id)&.where(start_datetime: reservation.start_datetime).empty?
        raise CustomException::NamedException::new(I18n.t('flash.reservation.create.fail.same_day'))
      elsif reservation.save
        reservation.update_attributes(
            price: (reservation.end_datetime - reservation.start_datetime).to_i/3600 * 1
        )
        return reservation
      else
        raise CustomException::NamedException::new(I18n.t('flash.reservation.create.fail.exec'))
      end
    end
  end

  def rental_start(reservation, tourist)
      if tourist.id != reservation.tourist_id
        raise CustomException::NamedException::new(I18n.t('flash.base.invalid'))
      end
      check_valid_start(reservation)
      #noinspection RubyResolve
      reservation.status_start!
  end

  def rental_end(reservation, tourist, problem)
    if tourist.id != reservation.tourist_id
      raise CustomException::NamedException::new()
    end
    validation = check_valid_end(reservation)
    if problem
      reservation.status_freeze!
      raise CustomException::ExpectedException::new(
          I18n.t('flash.reservation.end.success.problem'),
          t_reserve_path
      )
    else
      #noinspection RubyResolve
      reservation.status_end!
      if validation == END_BUT_DELAY
        raise CustomException::ExpectedException::new(
            I18n.t('flash.reservation.end.success.delay'),
            t_reserve_path
        )
      else
        return reservation
      end
    end
  end

  def delete_reservation(reservation, user)
    if user.id != Bike.find(reservation.bike_id).user_id
      raise CustomException::NamedException::new()
    elsif reservation.tourist_id.present?
      raise CustomException::NamedException::new(I18n.t('flash.reservation.delete.fail.filled'))
    elsif reservation.delete
      reservation
    else
      raise CustomException::NamedException::new(I18n.t('flash.reservation.delete.fail.exec'))
    end
  end

  private
  def check_valid_start(res)
    start_time = res.start_datetime
    end_time = res.end_datetime
    now = Time.now
    #noinspection RubyResolve
    if not res.status_default?
      raise CustomException::NamedException::new(I18n.t('flash.reservation.start.fail.already'))
    elsif end_time - 10.minutes < now
      DbLogger.dump("res:#{res.id} レンタル返却時刻10分前経過のため、貸出できてない。")
      raise CustomException::NamedException::new(I18n.t('flash.reservation.start.fail.limit'))
    elsif start_time > now
      raise CustomException::NamedException::new(I18n.t('flash.reservation.start.fail.early'))
    end
    true
  end


  END_BUT_DELAY = 1001
  END_COMPLETE = 1002
  def check_valid_end(res)
    end_time = res.end_datetime
    now = Time.now

    #noinspection RubyResolve
    unless res.status_start?
      raise CustomException::NamedException::new()
    end
    if end_time < now
      DbLogger.dump("res:#{res.id} 返却遅延 time=#{now}")
      return END_BUT_DELAY
    end

    END_COMPLETE
  end
end