class SessionsController < ApplicationController

  def u_new
    if user?
      redirect_to u_edit_path
    elsif tourist?
      redirect_to b_index_path
    end
  end

  def t_new
    if user?
      redirect_to u_edit_path
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
      flash[:success] = "ログインしました"
      if user?
        redirect_to u_edit_path
      elsif
        redirect_to b_index_path
      end
    else
      flash[:danger] = 'ログインに失敗しました'
      if flag == "user"
        redirect_to u_login_path
      elsif flag == "tourist"
        redirect_to t_login_path
      end
    end
  end

  def destroy
    if user?
      log_out
      redirect_to root_path
    elsif tourist?
      log_out
      redirect_to root_path
    end
  end

end
