class TouristBikesController < ApplicationController

  def reserve
    if_user do |user|
      @user = user
      permitted = permit_params
      @reserve = TouristBike.new(
        bike_id: permitted["bike_id"],
        start_datetime: Time.parse("#{permitted["date"]} #{permitted["start_datetime(4i)"]}:#{permitted["start_datetime(5i)"]}"),
        end_datetime: Time.parse("#{permitted["date"]} #{permitted["end_datetime(4i)"]}:#{permitted["end_datetime(5i)"]}"),
        place_id: permitted["place_id"]
      )
      if p @reserve.bike_id.nil?
        flash[:warning] = "自転車が選択されていません"
      elsif !@user.authenticated
        flash[:warning] = "メール認証を済ませて下さい"
      elsif Bike.find(@reserve.bike_id.to_i).user_id == @user.id
        if @reserve.start_datetime.nil?
          flash[:warning] = "日付を入力してください"
        elsif @reserve.start_datetime + 10.minutes > @reserve.end_datetime
          flash[:warning] = "開始時刻が終了時刻よりも早いです"
        elsif @reserve.start_datetime <= Time.now + 30.minutes
          flash[:warning] = "開始時刻の３０分前までにご登録下さい"
        elsif @reserve.start_datetime > Date.today.since(2.months)
          flash[:warning] = "2ヶ月以上先の予約はできません"
        elsif !TouristBike.where(bike_id: @reserve.bike_id)&.where(start_datetime: @reserve.start_datetime).empty?
          flash[:warning] = "同じ日に同じ自転車の貸出はできません"
        elsif @reserve.save
          flash[:success] = "新しく日程を追加しました"
          # redirect_to u_reserve_path
        else
          flash[:warning] = "失敗しました"
        end
      end
      redirect_to u_reserve_path
    end
  end

  #お支払画面
  def payment
    if_tourist do |user|
      @reserve = TouristBike.find(params[:id])
      unless @reserve.tourist_id.nil?
        redirect_to b_index_path
      end
      @bike = @reserve.bike
      @tourist = user
    end
  end

  #予約削除
  def delete
    if_user do |user|
      @user = user
      @reserve = TouristBike.find(params[:id])
      if @user.id != Bike.find(@reserve.bike_id).user_id
        redirect_to root_path
      elsif !@reserve.tourist_id.nil?
        flash[:warning] = "予約があるので削除できません"
      elsif @reserve.delete
        flash[:success] = "削除しました"
      else
        flash[:warning] = "削除できませんでした"
      end
      redirect_to u_reserve_path
    end
  end

  def start_rental
    if_tourist do |user|
      @reserve = TouristBike.find(params[:id])
      if user.id != @reserve.tourist_id
        redirect_to root_path
        return nil
      end
      validation = check_valid_start(@reserve)
      if validation[0] != 0
        flash[:warning] = validation[1]
        redirect_to t_reserve_path
        return nil
      end
      #noinspection RubyResolve
      @reserve.status_start!
      flash[:success] = "貸出を開始しました"
      redirect_to t_reserve_path
    end
  end

  def end_rental
    if_tourist do |user|
      @reserve = TouristBike.find(params[:id])
      if user.id != @reserve.tourist_id
        redirect_to root_path
        return nil
      end
      validation = check_valid_end(@reserve)
      if validation[0] != 0
        flash[:warning] = validation[1]
        redirect_to t_reserve_path
        return nil
      end
      if params["prob"] == "true"
        flash[:warning] = "メールを送信します。詳細をメールにてお伝え下さい"
        @reserve.status_freeze!
        redirect_to t_reserve_path
        return nil
      end
      #noinspection RubyResolve
      @reserve.status_end!
      flash[:success] = validation[1]
      redirect_to t_reserve_path
    end
  end

  private
  def permit_params
    params.permit(:bike_id, :date, :start_datetime, :end_datetime, :place_id)
  end


end
