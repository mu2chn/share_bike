ActiveAdmin.register Parking do
  permit_params :name, :lat, :lng, :description, :url

  form do |f|
    f.inputs do
      f.input :name
      f.input :lat
      f.input :lng
      f.input :description
      f.input :url
    end
    f.actions
  end
end