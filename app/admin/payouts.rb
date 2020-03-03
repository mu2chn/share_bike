ActiveAdmin.register Payout do
  actions :all, except: [:destroy, :new, :edit]

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :payout_version, :paid_id, :amount, :currency, :user_id, :target_email, :manual_input, :complete_dump, :send_text, :detail
  #
  # or
  #
  # permit_params do
  #   permitted = [:payout_version, :paid_id, :amount, :currency, :user_id, :target_email, :manual_input, :complete_dump, :send_text, :detail]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end


  member_action :to_payouts, method: :get do
    Payout.capture_from_rewards
    redirect_to admin_payouts_path, notice: "move to payouts"
  end
  action_item :to_payouts, only: :index do
    link_to 'ToPayouts', to_payouts_admin_payout_path(1)
  end

  index do
    id_column
    column :payout_version
    column :amount
    column :target_email
    column :manual_input
    column :detail
    actions
  end
end
