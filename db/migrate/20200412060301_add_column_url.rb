class AddColumnUrl < ActiveRecord::Migration[6.0]
  def change
    add_column :parking, :url, :text
  end
end
