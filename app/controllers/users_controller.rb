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
    redirect_to b_new_path

    # if @user.save(context: :create)
    #   AuthMailer.auth_user(@user).deliver_later
    #   log_in(@user)
    #   flash[:success] = I18n.t('flash.user.create.success.register')
    #   flash[:info] = I18n.t('flash.user.create.success.sendmail')
    #   redirect_to b_new_path
    # else
    #   render u_new_path
    # end
  end

  def authenticate
    @user = User.find_by(email: params[:email])
    p params[:auth]
    p @user.authenticate_url
    if @user.authenticated
      flash[:info] = "すでに認証が完了しています"
      redirect_to root_path
    elsif DateTime.now > @user.authenticate_expire + 1.day
      str_url = SecureRandom.urlsafe_base64(30)
      Tourist.update_attributes(authenticate_expire: DateTime.now, authenticate_url: str_url)
      AuthMailer.auth_tourist(@tourist).deliver_later
      flash[:info] = "有効期限が切れているため、urlを再送しました"
      redirect_to root_path
    elsif @user.authenticate_url== params[:auth]
      @user.update_attribute(:authenticated, true)
      AuthMailer.t_complete_auth(@user).deliver_later
      flash[:info]="認証が完了しました"
      redirect_to b_index_path
    end
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
      if @user.update_attributes(update_user_params)
        flash[:success] = "更新しました"
        redirect_to u_edit_path
      else
        flash[:warning] = "更新に失敗しました"
        redirect_to u_edit_path
      end
    end
  end

  def forget_pass
    email = params[:email]
    u = User.find_by(email: email)
    if u.present?
      p pass = SecureRandom.hex(3)
      u.update_attributes(password: pass)
      ForgetPass.tell(u, pass).deliver_later
    end
    flash[:success] = email + "へ仮パスワードを送信しました"
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
