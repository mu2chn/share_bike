ActiveAdmin.register Transaction do
  permit_params
  actions :all, except: [:destroy, :new, :edit ]

  filter :tourist

  index do
    id_column
    column :tourist
    column :created_at
    column :amount
    column :currency
    column :refunded
    column :void
    actions
  end


  form do |f|
    f.inputs do
    end
    f.actions
  end

end