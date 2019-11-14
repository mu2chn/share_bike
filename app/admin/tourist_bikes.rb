ActiveAdmin.register TouristBike do
  permit_params :user_prob, :tourist_prob, :place_id

  index do
    id_column
    column :bike
    column :tourist
    column :place_id
    column :rent_time
    column :day
    actions
  end

  filter :bike
  filter :tourist
  filter :created_at

  form do |f|
    f.inputs do
      f.input :place_id
      f.input :user_prob
      f.input :tourist_prob
    end
    f.actions
  end
end