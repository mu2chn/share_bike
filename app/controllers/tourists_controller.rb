class TouristsController < ApplicationController

  require 'securerandom'

  include TouristsService

  def reserve_detail
    if_tourist do |user|
      @reserve = TouristBike.find(params[:id])
      @bike = @reserve.bike
      @user = @bike.user
      @started = during_rental(@reserve)
      unless @reserve.tourist_id == user.id
        redirect_to root_path
      end
    end
  end

  def new
    if logged_in?
      redirect_to root_path
    end
    @user = Tourist.new
  end

  def create
    @tourist = create_tourist(user_params)
    flash[:info] = I18n.t('flash.tourist.create.success.register')
    flash[:info] = I18n.t('flash.tourist.create.success.sendmail')
    redirect_to b_index_path
  end

  def authenticate
    @tourist = Tourist.find_by(email: params[:email])
    authenticate_tourist_by_code(@tourist, params[:auth])
    flash[:info] = I18n.t('flash.tourist.authenticate.success.clear')
    redirect_to b_index_path
  end

  def edit
    if_tourist do |user|
      @user = user
    end
  end

  def update
    if_tourist do |user|
      @user = user
      update_tourist(user, update_user_params)
      flash[:success] = I18n.t('flash.tourist.update.success.exec')
      redirect_to t_edit_path
    end
  end

  def forget_pass
    email = params[:email]
    reset_password(email)
    flash[:success] = I18n.t('flash.tourist.password_reset.success.sendto', email: email)
    redirect_to t_login_path
  end

  def reserve
    if_tourist do |user|
      @user = user
      @reservations = TouristBike.where(tourist_id: @user.id, end_datetime: DateTime.now.ago(3.days)..DateTime.now.since(14.days)).order(start_datetime: "ASC").page(params[:page]).per(8)
      flash[:success] = I18n.t('flash.tourist.reserve.end') if params[:payment]=="true"
    end
  end

  def user_params
    params.require(:tourist).permit(:name, :email, :phmnumber, :password, :temp_terms,
                                 :password_confirmation)
  end

  def update_user_params
    dict = {}
    params.require(:tourist).permit(:password, :password_confirmation).each do |key, content|
      if content != ""
        dict[key] = content
      end
    end
    return dict
  end
end
