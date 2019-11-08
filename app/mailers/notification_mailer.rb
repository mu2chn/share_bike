class NotificationMailer < ApplicationMailer
  default from: "info@mail.kyotosharebike.com"

  def payment_confirm_to_user(user, reserve)
    @user = user
    @reserve = reserve
    mail(
        subject: "自転車の予約が完了しました/Complete Reservation",
        to: @user.email
    ) do |format|
      format.text
    end
  end
end
