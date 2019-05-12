class TouristsController < ApplicationController
  include TouristsHelper

  include SessionsHelper

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
      redirect_to t_edit_path
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
        #TODO 更新成功時
      else

      end
    end
  end

  def user_params
    params.require(:tourist).permit(:name, :email, :phmnumber, :address, :password,
                                 :password_confirmation)
  end

  def update_user_params
    dict = {}
    params.require(:tourist).permit(:address, :password, :password_confirmation).each do |key, content|
      if content != ""
        dict[key] = content
      end
    end
    return dict
  end
end
