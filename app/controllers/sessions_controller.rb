class SessionsController < ApplicationController
  include SessionsHelper

  def u_new
    if logged_in?
      redirect_to  root_path
    end
  end
  def t_new
    if logged_in?
      redirect_to root_path
    end
  end

  # User, Tourist共通処理
  def create
    if params[:session][:type] == "user"
      user = User.find_by(email: params[:session][:email].downcase)
    elsif params[:session][:type] == "tourist"
      user = Tourist.find_by(email: params[:session][:email].downcase)
    end
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to root_path
    else
      # flash.now[:danger] = 'Invalid email/password combination'
      render 'users/new'
    end
  end

  def destroy
    if user?
      log_out
      redirect_to 'u-login'
    elsif tourist?
      log_out
      redirect_to 't-login'
    end
  end

end
