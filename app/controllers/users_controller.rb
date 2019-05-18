class UsersController < ApplicationController

  def new
    if logged_in?
      redirect_to root_path
    end
    @user = User.new
  end

  def create
    p params
    @user = User.new(user_params)
    if @user.save(context: :create)
      log_in(@user)
      flash[:success] = "登録が完了しました！さっそく自転車を追加してみましょう。"
      redirect_to b_new_path
    else
      render u_new_path
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
                          .where(day: Date.today.ago(2.days)...Date.today.since(2.months))
                          .order(day: "ASC").page(params[:page]).per(8)
    end
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
      if @user.update_attributes(update_user_params)
        flash[:success] = "Updated"
        redirect_to u_edit_path
      else
        render u_edit_path
      end
    end
  end

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
