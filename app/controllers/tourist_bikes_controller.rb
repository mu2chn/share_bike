class TouristBikesController < ApplicationController
  def reserve
    if_user do |user|
      @user = user
      @reserve = TouristBike.new(permit_params)
      if Bike.find(@reserve.bike_id.to_i).user_id == @user.id
        if p @reserve.save
          flash[:success] = "追加しました"
          # redirect_to u_reserve_path
        else
          flash[:danger] = "失敗しました"
        end
      end
      redirect_to u_reserve_path
    end
  end

  def delete
    if_user do |user|
      @user = user
      @reserve = TouristBike.find(params[:id])
      if @user.id != Bike.find(@reserve.bike_id).user_id
        redirect_to root_path
      elsif !@reserve.tourist_id.nil?
        flash[:danger] = "予約があるので削除できません"
      else
        @reserve.delete
        flash[:success] = "削除しました"
      end
      redirect_to u_reserve_path
    end
  end

  def permit_params
    params.require(:tourist_bike).permit(:bike_id, :day)
  end
end
