class ReserveDetail < ActiveRecord::Migration[5.1]
  def change
    add_column :tourist_bikes, :place_id, :integer
    add_column :tourist_bikes, :rent_time, :time
  end
end
