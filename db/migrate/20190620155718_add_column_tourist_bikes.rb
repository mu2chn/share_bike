class AddColumnTouristBikes < ActiveRecord::Migration[5.1]
  def change
    add_column :tourist_bikes, :user_prob, :integer
    add_column :tourist_bikes, :tourist_prob, :integer
  end
end
