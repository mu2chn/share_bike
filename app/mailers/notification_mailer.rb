class NotificationMailer < ApplicationMailer
  # default from: "info@mail.kyotosharebike.com"

  # def payment_confirm_to_user(user, reserve)
  def send_confirm_to_user(user, reserve)
  @user = user
    @reserve = reserve
    mail(
        subject: "自転車の予約が完了しました/Complete Reservation",
        to: @user.email
    ) do |format|
      format.text
    end
  end

  def soon_rental_confirm_to_user(reserve)
    @reserve = reserve
    @user = reserve.bike.user
    mail(
        subject: "明後日が京都での自転車旅行です！",
        to: @user.email
    ) do |format|
      format.text
    end
  end

  def start_rental_confirm_to_user(reserve)
    @reserve = reserve
    @user = reserve.bike.user
    mail(
        subject: "自転車旅行は本日です！",
        to: @user.email
    ) do |format|
      format.text
    end
  end

  def tomorrow_rental_confirm_to_user(reserve)
    @reserve = reserve
    @user = reserve.bike.user
    mail(
        subject: "自転車旅行は明日です！",
        to: @user.email
    ) do |format|
      format.text
    end
  end
end
