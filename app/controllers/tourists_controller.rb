class TouristsController < ApplicationController

  def new
    if logged_in?
      redirect_to root_path
    end
    @user = Tourist.new
  end

  def create
    @user = Tourist.new(user_params)
    if @user.save
      log_in(@user)
      flash[:info] = "乗りたいバイクを探して見ましょう！"
      redirect_to b_index_path
    else
      render t_new_path
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
