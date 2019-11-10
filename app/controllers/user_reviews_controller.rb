class UserReviewsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def add_review
    @reserve = TouristBike.find(params[:reserve])
    if @reserve.tourist_id == params[:key].to_i
      if UserReview.create!(user_id: @reserve.bike.user_id, tourist_bike_id: @reserve.id, rate: params[:rate], comment: params[:comment])
        render json: {}, status: :created
      else
        render json: {msg: "cannot create"}, status: :unprocessable_entity
      end
    else
      render json: {msg: "key false"}, status: :unprocessable_entity
    end
  end

  def set_review
    # @user_review = UserReview.new
    @reserve = TouristBike.find(params[:reserve])
    @user = User.find(@reserve.bike.user_id)
    @tourist = Tourist.find(@reserve.tourist_id)
  end

  private
  def review_params
    params.require(:user_review).permit(:user_id, :tourist_bike_id, :rate, :comment)
  end
end
