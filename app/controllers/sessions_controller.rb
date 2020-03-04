class SessionsController < ApplicationController

  def u_new
    if user?
      redirect_to b_index_path
    elsif tourist?
      redirect_to b_index_path
    end
  end

  def t_new
    if user?
      redirect_to b_index_path
    elsif tourist?
      redirect_to b_index_path
    end
  end

  # User, Tourist共通処理
  def create
    if params[:session][:type] == "user"
      user = User.find_by(email: params[:session][:email].downcase)
      flag = "user"
    elsif params[:session][:type] == "tourist"
      user = Tourist.find_by(email: params[:session][:email].downcase)
      flag = "tourist"
    end
    if user && user.authenticate(params[:session][:password])
      log_in user
      remember user, flag
      flash[:success] = "ログインしました"
      if user?
        redirect_to u_reserve_path
      elsif tourist?
        redirect_to b_index_path
      end
    else
      flash[:warning] = "ログインに失敗しました。メールアドレスやパスワードが間違っていないか確認してください。"
      if flag == "user"
        redirect_to u_login_path
      elsif flag == "tourist"
        redirect_to t_login_path
      end
    end
  end

  def destroy
    if logged_in?
      current_user.forget
      cookies.delete(:user_id)
      cookies.delete(:tourist_id)
      cookies.delete(:remember_token)
      if user?
        log_out
        redirect_to root_path
      elsif tourist?
        log_out
        redirect_to root_path
      end
      flash[:success] = "ログアウトしました"
    else
      flash[:warning] = "すでにログアウトしています"
      redirect_to root_path
    end
  end
end
