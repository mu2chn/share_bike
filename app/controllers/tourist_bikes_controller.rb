class TouristBikesController < ApplicationController

  include TouristBikesService

  def reserve
    if_user do |user|
      @user = user
      permitted = permit_params
      @reserve = TouristBike.new(
        bike_id: permitted["bike_id"],
        start_datetime: Time.parse("#{permitted["date"]} #{permitted["start_datetime(4i)"]}:#{permitted["start_datetime(5i)"]}"),
        end_datetime: Time.parse("#{permitted["date"]} #{permitted["end_datetime(4i)"]}:#{permitted["end_datetime(5i)"]}"),
        place_id: permitted["place_id"]
      )
      create_reserve(@reserve, user)
      flash[:success] = I18n.t('flash.reservation.create.success.exec')
      redirect_to u_reserve_path
    end
  end

  #お支払画面
  def payment
    if_tourist do |user|
      @reserve = TouristBike.find(params[:id])
      unless @reserve.tourist_id.nil?
        redirect_to b_index_path
      end
      @bike = @reserve.bike
      @tourist = user
      @deposit = Payment::DEPOSIT
    end
  end

  #予約削除
  def delete
    if_user do |user|
      @user = user
      @reserve = TouristBike.find(params[:id])
      delete_reservation(@reserve, @user)
      flash[:success] = I18n.t('flash.reservation.delete.success.exec')
      redirect_to u_reserve_path
    end
  end

  def start_rental
    if_tourist do |user|
      @reserve = TouristBike.find(params[:id])
      rental_start(@reserve, user)
      flash[:success] = I18n.t('flash.reservation.start.success.exec')
      redirect_to t_reserve_path
    end
  end

  def end_rental
    if_tourist do |user|
      @reserve = TouristBike.find(params[:id])
      problem = (params["prob"] == "true")
      rental_end(@reserve, user, problem)
      flash[:success] = I18n.t('flash.reservation.end.success.exec')
      redirect_to t_reserve_path
    end
  end

  private
  def permit_params
    params.permit(:bike_id, :date, :start_datetime, :end_datetime, :place_id)
  end
end
