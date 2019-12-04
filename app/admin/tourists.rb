ActiveAdmin.register Tourist do
  permit_params :name, :authenticated, :nickname, :phmnumber, :void, :tutorial
  actions :all, except: [:destroy, :new ]

  index do
    id_column
    column :name
    column :email
    column :created_at
    actions
  end

  filter :email
  filter :name
  filter :created_at

  form do |f|
    f.inputs do
      f.input :name
      f.input :tutorial
      #f.input :temp_terms
      f.input :authenticated
      f.input :void
    end
    f.actions
  end
end