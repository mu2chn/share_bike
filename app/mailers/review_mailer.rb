class ReviewMailer < ApplicationMailer
  def tourist_review(reserve)
    @user = Tourist.find(reserve.tourist_id)
    @reserve = reserve
    mail(
        subject: "レビューにご協力ください！",
        to: @user.email
    ) do |format|
      format.text
    end
  end
end
