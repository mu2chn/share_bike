class UsersController < ApplicationController
  include SessionsHelper

  def new
    if logged_in?
      redirect_to root_path
    end
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to u_edit_path
    else
      render u_new_path
    end
  end

  def show
    @user = User.find(params[:id])
    @bikes = Bike.where(user_id: @user.id)
  end

  def edit
    if_user do |user|
      @user = user
      @bikes = Bike.where(user_id: @user.id)
    end
  end

  def update
    if_user do |user|
      @user = user
      if p @user.update_attributes(update_user_params)
        #TODO 更新成功時
      else

      end
    end
  end

  def user_params
    params.require(:user).permit(:name, :nickname, :email, :password,
                                 :password_confirmation)
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
