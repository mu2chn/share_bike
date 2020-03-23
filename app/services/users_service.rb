module UsersService

  include ApplicationService

  def create_user(user)
    if user.save(context: :create)
      AuthMailer.auth_user(user).deliver_later
      log_in(user)
      user
    else
      raise CustomException::NamedException::new(I18n.t('flash.user.create.fail.register'))
    end
  end
end