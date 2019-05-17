class TouristBikesController < ApplicationController

  def reserve
    if_user do |user|
      @user = user
      @reserve = TouristBike.new(permit_params)
      if Bike.find(@reserve.bike_id.to_i).user_id == @user.id
        if @reserve.day <= Date.today
          flash[:warning] = "今日以前の日付は無効です"
        elsif @reserve.day > Date.today.since(2.months)
          flash[:warning] = "2ヶ月以上先の予約はできません"
        elsif !TouristBike.where(bike_id: @reserve.bike_id)&.where(day: @reserve.day).empty?
          flash[:warning] = "同じ日に同じ自転車の貸出はできません"
        elsif @reserve.save
          flash[:success] = "新しく日程を追加しました"
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
      elsif @reserve.delete
        flash[:success] = "削除しました"
      else
        flash[:danger] = "削除できませんでした"
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
        redirect_to b_show_path(@reserve.bike_id)
      elsif @reserve.update(tourist_id: @user.id)
        flash[:success] = "予約しました"
        redirect_to t_reserve_path
      else
        flash[:danger] = "予約に失敗しました"
        redirect_to b_show_path(@reserve.bike_id)
      end
    end
  end

  def permit_params
    params.require(:tourist_bike).permit(:bike_id, :day)
  end

end