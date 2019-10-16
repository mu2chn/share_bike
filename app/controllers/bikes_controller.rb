class BikesController < ApplicationController

  def index
    @bikes = Bike.joins(:tourist_bikes).eager_load(:tourist_bikes).easy_search_and(params[:search])
    dsearch = search_by_date(params[:dsearch])
    if dsearch != nil
      @bikes = @bikes.where(tourist_bikes: {day: dsearch})
    end
    @bikes = @bikes.page(params[:page]).per(9)
    days = ((Date.tomorrow...Date.tomorrow.end_of_month).to_a[1..-1] + (Date.tomorrow.end_of_month..Date.today.next_month).to_a)
    @date_hash = days.map do |date|
      [ "#{date.month}月#{date.day}日（#{[ "日", "月", "火", "水", "木", "金", "土"][date.wday]}）", date.day]
    end.to_a
    @prev_day = dsearch

    if user = current_user
      user.update_attribute(:tutorial,
                            tutorial(user.tutorial, 0, "ここは自転車検索ページです。日程などから自転車を探すことができます"))
    end
  end

  def show
    @bike = Bike.find(params[:id])
    @reservations = TouristBike.where(bike_id: @bike.id)
                        .where(day: Date.tomorrow...Date.today.since(2.months))
                        .order(day: "ASC").page(params[:page]).per(4)
    if user = current_user
      user.update_attribute(:tutorial,
                            tutorial(user.tutorial, 1, "ここは予約ページです。気に入った自転車の予約をすることができます。"))
    end
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
        flash[:success] = "新しく自転車を追加しました！今度は貸し出す日程を決めましょう"
        redirect_to u_reserve_path
      else
        render b_new_path
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
          flash[:error] = "失敗しました"
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

  def search_by_date(day)
    if day.nil? || day == ""
      return nil
    end
    day = day.to_i
    search_date = Date.today
    if search_date.day >= day
      search_date = search_date.next_month
      search_date = search_date.ago((search_date.day-day).days)
    else
      search_date = search_date.since((day-search_date.day).days)
    end
    search_date
  end
end
