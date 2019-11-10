class RentalStatus < ActiveRecord::Migration[5.1]
  def change
    add_column :tourist_bikes, :status, :integer, default: 0
  end
end
