class AuthMailer < ApplicationMailer

  # default from: "info@mail.kyotosharebike.com"

  def auth_tourist(user)
    @user = user
    mail(
        subject: "以下のリンクを踏んでメール認証をして下さい。",
        to: @user.email #宛先
    ) do |format|
      format.text
    end
  end

  def t_complete_auth(user)
    @user = user
    mail(
        subject: "メール認証が完了しました。",
        to: @user.email #宛先
    ) do |format|
      format.text
    end
  end

  def auth_user(user)
    @user = user
    mail(
        subject: "以下のリンクを踏んでメール認証をして下さい。",
        to: @user.email #宛先
    ) do |format|
      format.text
    end
  end

  def u_complete_auth(user)
    @user = user
    mail(
        subject: "メール認証が完了しました。",
        to: @user.email #宛先
    ) do |format|
      format.text
    end
  end

end
