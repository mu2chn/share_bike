class NotificationMailer < ApplicationMailer
  default from: "matsuyamapopo3@gmail.com"

  def send_confirm_to_user(user)
    @user = user
    mail(
        subject: "以下のリンクにより、メール認証を行います",
        to: @user.email #宛先
    ) do |format|
      format.text
    end
  end
end
