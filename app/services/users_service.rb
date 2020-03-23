module UsersService

  include ApplicationService

  # ユーザーの作成をします
  def create_user(user)
    if user.save(context: :create)
      AuthMailer.auth_user(user).deliver_later
      log_in(user)
      user
    else
      raise CustomException::NamedException::new(I18n.t('flash.user.create.fail.register'))
    end
  end

  # ユーザーの認証を行います
  def authenticate_user_by_code(user, auth_code)
    if user.authenticated
      raise CustomException::NamedException::new(I18n.t('flash.user.authenticate.fail.already'))
    elsif DateTime.now > user.authenticate_expire + 1.day
      str_url = SecureRandom.urlsafe_base64(30)
      Tourist.update_attributes(authenticate_expire: DateTime.now, authenticate_url: str_url)
      AuthMailer.auth_user(user).deliver_later
      raise CustomException::NamedException::new(I18n.t('flash.user.authenticate.fail.expired'))
    elsif user.authenticate_url == auth_code
      user.update_attribute(:authenticated, true)
      AuthMailer.t_complete_auth(user).deliver_later
      user
    else
      raise CustomException::NamedException::new(I18n.t('flash.base.unknown'))
    end
  end

  # ユーザー情報の更新
  def update_user(user, params)
    if user.update_attributes(params)
      user
    else
      raise CustomException::NamedException::new(I18n.t('flash.user.update.fail.exec'))
    end
  end

  # パスワード再設定
  def reset_password(email)
    user = User.find_by(email: email)
    if user.present?
      pass = SecureRandom.hex(3)
      user.update_attributes(password: pass)
      ForgetPass.tell(user, pass).deliver_later
    else
      # Emailの登録判定を防ぐため、何もしない
    end
  end
end