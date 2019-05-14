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

  def accept
    if_tourist do |user|
      @user = user
      @reserve = TouristBike.find(params[:id])
      if !@reserve.tourist_id.nil?
        flash[:danger] = "すでに予約が入っています"
      else
        @reserve.tourist_id = params[:id]
        @reserve.update(tourist_id: params[:id])
        flash[:success] = "予約しました"
      end
      redirect_to b_show_path(@reserve.bike_id)
    end
  end

  def permit_params
    params.require(:tourist_bike).permit(:bike_id, :day)
  end

end