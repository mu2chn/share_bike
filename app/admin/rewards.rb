ActiveAdmin.register Reward do
  actions :all, except: [:destroy, :new, :edit]
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :amount, :currency, :user_id, :already_payout, :tourist_bike_id, :payout_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:amount, :currency, :user_id, :already_payout, :tourist_bike_id, :payout_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  #

  filter :tourist_bike_id
  filter :user_id

  index do
    id_column
    column :user
    column :tourist_bike
    column :payout
    actions
  end

end
