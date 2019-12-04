ActiveAdmin.register User do
  permit_params :name, :authenticated, :nickname, :void
  actions :all, except: [:destroy, :new ]

  filter :email
  filter :name
  filter :created_at

  index do
    id_column
    column :name
    column :email
    column :created_at
    actions
  end


  form do |f|
    f.inputs do
      f.input :name
      f.input :authenticated
      f.input :void
    end
    f.actions
  end

end