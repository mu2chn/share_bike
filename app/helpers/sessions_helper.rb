module SessionsHelper

  def if_login
    if logged_in?
      yield(current_user)
    else
      redirect_to root_path
    end
  end

  def if_user
    if user?
      yield(current_user)
    else
      redirect_to root_path
    end
  end

  def if_tourist
    if tourist?
      yield(current_user)
    else
      redirect_to root_path
    end
  end

  def log_in(user)
    if p user.kind_of?(User)
      session[:user_id] = user.id
    elsif user.kind_of?(Tourist)
      session[:tourist_id] = user.id
    end
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
    elsif session[:tourist_id]
      @current_user ||= Tourist.find(session[:tourist_id])
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def user?
    current_user.kind_of?(User)
  end

  def tourist?
    current_user.kind_of?(Tourist)
  end

  def log_out
    session.delete(:user_id)
    session.delete(:tourist_id)
    @current_user = nil
  end
end
