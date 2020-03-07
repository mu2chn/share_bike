class ForgetPass < ApplicationMailer

  # default from: "info@mail.kyotosharebike.com"

  def tell(user, pass)
    @user = user
    @pass = pass
    mail(
        subject: "仮パスワードを発行しました",
        to: @user.email #宛先
    ) do |format|
      format.text
    end
  end
  #
  # def t_tell(user, pass)
  #   @user = user
  #   @pass = pass
  #   mail(
  #       subject: "仮パスワードを発行しました",
  #       to: @user.email #宛先
  #   ) do |format|
  #     format.text
  #   end
  # end
end
