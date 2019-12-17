class Api::TouristBikesController < ApplicationController
  def my_reward
    @user = User.find(params[:id])
    if @user
      Reward.where(user_id: @user.id).where(end_datetime: Time.now.beginning_of_month..Time.now.end_of_month)
    else
      render json: {msg: "ユーザーが見つかりません"}, status: :unprocessable_entity
    end
  end
end