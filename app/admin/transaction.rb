ActiveAdmin.register Transaction do
  permit_params
  actions :all, except: [:destroy, :new, :edit ]

  filter :tourist
  filter :id

  index do
    id_column
    column :tourist
    column :created_at
    column :amount
    column :currency
    actions
  end


  form do |f|
    f.inputs do
    end
    f.actions
  end

  action_item :order_detail, only: :show do
    link_to 'Details', order_detail_admin_transaction_path
  end

  member_action :order_detail, method: :get do
    status = resource.show_order[1][:result][:payer]#[:purchase_units]
    redirect_to resource_path, notice: "DETAIL === #{status}"
  end

end