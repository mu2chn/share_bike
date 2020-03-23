require 'securerandom'

class UsersController < ApplicationController

  include UsersService

  def new
    if logged_in?
      redirect_to root_path
    end
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    create_user(@user)
    flash[:success] = I18n.t('flash.user.create.success.register')
    flash[:info] = I18n.t('flash.user.create.success.sendmail')
    redirect_to b_new_path
  end

  def authenticate
    @user = User.find_by(email: params[:email])
    authenticate_user_by_code(@user, params[:auth])
    flash[:success] = I18n.t('flash.user.authenticate.success.clear')
    redirect_to b_index_path
  end

  def show
    @user = User.find(params[:id])
    @bikes = Bike.where(user_id: @user.id)
  end

  def reserve
    if_user do |user|
      @user = user
      @reserve = TouristBike.new
      @bikes = Bike.where(user_id: @user.id)
      @reservations = TouristBike.where(bike_id: @bikes.map{|b| b.id })
                          .where(start_datetime: Date.today.ago(2.days)...Date.today.since(2.months))
                          .order(start_datetime: "ASC").page(params[:page]).per(8)
    end
  end

  def edit
    if_user do |user|
      @user = user
      @bikes = Bike.where(user_id: @user.id)
      @reserve = TouristBike.includes(:reward).references(:reward).where(bike_id: @bikes)
    end
  end

  def update
    if_user do |user|
      @user = user
      update_user(user, update_user_params)
      flash[:success] = I18n.t('flash.user.update.success.exec')
      redirect_to u_edit_path
    end
  end

  def forget_pass
    email = params[:email]
    reset_password(email)
    flash[:success] = I18n.t("flash.user.password_reset.success.sendto", email: email)
    redirect_to u_login_path
  end

  private
  def user_params
    params.require(:user).permit(:name, :nickname, :email, :password,
                                 :password_confirmation, :temp_terms)
  end

  def update_user_params
    dict = {}
    params.require(:user).permit(:nickname, :password, :password_confirmation).each do |key, content|
      if content != ""
        dict[key] = content
      end
    end
    return dict
  end
end
