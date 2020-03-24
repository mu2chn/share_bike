ActiveAdmin.register TouristBike do
  permit_params :user_prob, :tourist_prob, :place_id, :end_datetime, :start_datetime, :void, :status
  actions :all, except: [:destroy, :new]

  index do
    id_column
    column :bike
    column :tourist
    column :place_id
    column :start_datetime
    column :end_datetime
    actions
  end

  filter :bike
  filter :tourist
  filter :created_at

  form do |f|
    f.inputs do
      f.input :place_id
      f.input :start_datetime
      f.input :end_datetime
      f.input :user_prob
      f.input :tourist_prob
      f.input :status
      f.input :void
    end
    f.actions
  end

  action_item :cancel, only: :edit do
    link_to 'Cancel Reserve (Refund)', cancel_admin_tourist_bike_path
  end
  action_item :get_deposit, only: :edit do
    link_to 'Get Deposit', get_deposit_admin_tourist_bike_path
  end
  action_item :refund_deposit, only: :edit do
    link_to 'Refund Deposit', refund_deposit_admin_tourist_bike_path
  end
  action_item :dump_reward, only: :edit do
    link_to 'Dump Reward Manually', dump_reward_admin_tourist_bike_path
  end
  action_item :freeze_reserve, only: :edit do
    link_to '問題発生', freeze_reserve_admin_tourist_bike_path
  end
  member_action :cancel, method: :get do
    begin
      status = resource.cancel
    rescue => e
      status = e.msg
    end
    redirect_to resource_path, notice: "METHOD=Cancel #{status}"
  end

  member_action :get_deposit, method: :get do
    begin
      status = resource.get_deposit
    rescue => e
      status = e.msg
    end
    redirect_to resource_path, notice: "METHOD=getDeposit #{status}"
  end

  member_action :refund_deposit, method: :get do
    begin
      status = resource.refund_deposit
    rescue => e
      status = e.msg
    end
    redirect_to resource_path, notice: "METHOD=refundDeposit #{status}"
  end

  member_action :dump_reward, method: :get do
    begin
      status = resource.dump_reward
    rescue => e
      status = e.msg
    end
    redirect_to resource_path, notice: "METHOD=dumpReward #{status}"
  end

  member_action :freeze_reserve, method: :get do
    begin
      status = resource.freeze_reserve
    rescue => e
      status = e.msg
    end
    redirect_to resource_path, notice: "METHOD=freezeReserve #{status}"
  end
end