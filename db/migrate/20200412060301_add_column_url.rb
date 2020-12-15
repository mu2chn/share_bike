class AddColumnUrl < ActiveRecord::Migration[6.0]
  def change
    add_column :parkings, :url, :text
  end
end
