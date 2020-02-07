class TouristsController < ApplicationController

  require 'securerandom'

  def reserve_detail
    if_tourist do |user|
      @reserve = TouristBike.find(params[:id])
      @user = @reserve.bike.user
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
    custom_params = user_params
    @user = Tourist.new(custom_params)
    if @user.save
      AuthMailer.auth_tourist(@user).deliver_later
      log_in(@user)
      flash[:info] = "乗りたいバイクを探して見ましょう！"
      flash[:info] = "登録したメール宛に認証リンクを送信しました。（メールにあるリンクを踏まないと自転車の予約ができません。）"
      redirect_to b_index_path
    else
      render t_new_path
    end
  end

  def authenticate
    @tourist = Tourist.find_by(email: params[:email])
    p params[:auth]
    p @tourist.authenticate_url
    if @tourist.authenticated
      flash[:info] = "すでに認証が完了しています"
      redirect_to root_path
    elsif DateTime.now > @tourist.authenticate_expire + 1.day
      str_url = SecureRandom.urlsafe_base64(30)
      Tourist.update_attributes(authenticate_expire: DateTime.now, authenticate_url: str_url)
      AuthMailer.auth_tourist(@tourist).deliver_later
      flash[:info] = "有効期限が切れているため、urlを再送しました"
      redirect_to root_path
    elsif @tourist.authenticate_url== params[:auth]
      @tourist.update_attribute(:authenticated, true)
      AuthMailer.t_complete_auth(@tourist).deliver_later
      flash[:info]="認証が完了しました"
      redirect_to b_index_path
    end
  end

  def edit
    if_tourist do |user|
      @user = user
    end
  end

  def update
    if_tourist do |user|
      @user = user
      if @user.update_attributes(update_user_params)
        flash[:success] = "Updated"
        redirect_to t_edit_path
      else
        render t_edit_path
      end
    end
  end

  def reserve
    if_tourist do |user|
      @user = user
      @reservations = TouristBike.where(tourist_id: @user.id).order(day: "ASC").page(params[:page]).per(8)
      flash[:success]="支払いが完了しました!" if params[:payment]=="true"
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
