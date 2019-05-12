class BikesController < ApplicationController

  def index
    @bikes = Bike.all
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
        redirect_to u_edit_path
      end
    end
  end

  def bike_params
    params.require(:bike).permit(:name, :vehicle_num, :security_area, :security_num, :details, :image)
  end
end
