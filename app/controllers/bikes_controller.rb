class BikesController < ApplicationController

  include BikesService

  def index
    dsearch = nil
    if params["dsearch"].present?
      dsearch = Time.parse(params[:dsearch])
      @reservations = TouristBike.where(start_datetime: Time.now..(Time.now+10.days)).where(start_datetime: dsearch..dsearch+1.days).order(:start_datetime).page(params[:page]).per(9)
    else
      @reservations = TouristBike.where(start_datetime: Time.now..(Time.now+10.days)).order(:start_datetime).page(params[:page]).per(9)
    end

    @prev_day = dsearch
    @date_hash = make_month

    tutorial_index(current_user)
  end

  def show
    @bike = Bike.find(params[:id])
    @reservations = TouristBike.where(bike_id: @bike.id)
                        .where(start_datetime: (Time.now)...Time.now.since(2.weeks))
                        .order(start_datetime: "ASC").page(params[:page]).per(4)
    tutorial_show(current_user)
  end

  def new
    @bike = Bike.new
  end

  def create
    if_user do |user|
      @user = user
      @bike = create_bike(bike_params, user)
      flash[:success] = I18n.t('flash.bike.create.success.register')
      redirect_to u_reserve_path
    end
  end

  def edit
    if_user do |user|
      @user = user
      @bike = Bike.find(params[:id])
    end
  end

  def update
    if_user do |user|
      @user = user
      @bike = Bike.find(params[:id])
      update_bike(@bike, bike_update_params, user)
      flash[:success] = I18n.t('flash.bike.update.success.exec')
      redirect_to b_edit_path(bike.id)
    end
  end

  private
  def bike_params
    params.require(:bike).permit(:name, :vehicle_num, :security_area, :security_num, :details, :image, :pass)
  end

  def bike_update_params
    params.require(:bike).permit(:name, :details, :image, :pass)
  end

end
