module TouristsService

  include ApplicationService

  # touristの作成
  def create_tourist(params)
    tourist = Tourist.new(params)
    if tourist.save
      AuthMailer.auth_tourist(tourist).deliver_later
      log_in(tourist)
      tourist
    else
      raise CustomException::NamedException::new(I18n.t('flash.tourist.create.fail.register'))
    end
  end

  # touristの認証
  def authenticate_tourist_by_code(tourist, auth_code)
    if tourist.authenticated
      raise CustomException::NamedException::new(I18n.t('flash.tourist.authenticate.fail.already'))
    elsif DateTime.now > tourist.authenticate_expire + 1.day
      str_url = SecureRandom.urlsafe_base64(30)
      Tourist.update_attributes(authenticate_expire: DateTime.now, authenticate_url: str_url)
      AuthMailer.auth_tourist(tourist).deliver_later
      raise CustomException::NamedException::new(I18n.t('flash.tourist.authenticate.fail.expired'))
    elsif tourist.authenticate_url == auth_code
      tourist.update_attribute(:authenticated, true)
      AuthMailer.t_complete_auth(tourist).deliver_later
      tourist
    else
      raise CustomException::NamedException::new(I18n.t('flash.base.unknown'))
    end
  end

  # update_tourist
  def update_tourist(tourist, params)
    if tourist.update_attributes(params)
      tourist
    else
      raise CustomException::NamedException::new(I18n.t('flash.tourist.update.fail.exec'))
    end
  end

  def reset_password(email)
    tourist = Tourist.find_by(email: email)
    if tourist.present?
      pass = SecureRandom.hex(3)
      tourist.update_attributes(password: pass)
      ForgetPass.tell(tourist, pass).deliver_later
    end
    tourist
  end
end