ActiveAdmin.register User do
  permit_params :name, :authenticated, :nickname
  actions :all, except: [:destroy ]

  filter :email
  filter :nikname
  filter :name
  filter :created_at

  index do
    id_column
    column :name
    column :nickname
    column :email
    column :created_at
    actions
  end


  form do |f|
    f.inputs do
      f.input :name
      f.input :nickname
      f.input :authenticated
    end
    f.actions
  end

end