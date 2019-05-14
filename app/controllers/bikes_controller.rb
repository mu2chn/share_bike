class BikesController < ApplicationController

  def index
    @bikes = Bike.easy_search_and(params[:search]).page(params[:page]).per(1)
  end

  def show
    @bike = Bike.find(params[:id])
  end

  def new
    @bike = Bike.new
  end

  def create
    if_user do |user|
      @user = user
      @bike = Bike.new(bike_params)
      @bike.user_id = @user.id
      if @bike.save
        redirect_to "/bikes/edit/"+@bike.id.to_s
      end
    end
  end

  def edit
    if_user do |user|
      @user = user
      @bike = Bike.find(params[:id])
    end
  end

  def update
    if_user do |user|
      @user = user
      @bike = Bike.find(params[:id])
      if @bike.user_id == user.id
        if @bike.update_attributes(bike_update_params)
          flash[:success] = "Updated"
          redirect_to "/bikes/edit/"+params[:id].to_s
        else
          flash[:danger] = "失敗しました"
          redirect_to "/bikes/edit/"+params[:id].to_s
        end
      else
        flash[:error] = "権限がありません"
        redirect_to root_path
      end
    end
  end

  def bike_params
    params.require(:bike).permit(:name, :vehicle_num, :security_area, :security_num, :details, :image)
  end

  def bike_update_params
    params.require(:bike).permit(:name, :details, :image)
  end
end
