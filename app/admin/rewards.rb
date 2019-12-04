ActiveAdmin.register Reward do
  actions :all
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
   permit_params :amount, :currency, :user_id, :already_payout, :tourist_bike_id, :payout_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:amount, :currency, :user_id, :already_payout, :tourist_bike_id, :payout_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
