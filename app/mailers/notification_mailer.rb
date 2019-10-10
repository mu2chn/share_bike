class NotificationMailer < ApplicationMailer
  default from: "mail.kyoto.bike@gmail.com"

  def send_confirm_to_user(user)
    @user = user
    mail(
        subject: "自転車の予約が完了しました/Complete Reservation", #メールのタイトル
        to: @user.email
    ) do |format|
      format.text
    end
  end
end
