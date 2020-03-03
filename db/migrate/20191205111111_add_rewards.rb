class AddRewards < ActiveRecord::Migration[6.0]
  def change
    add_reference :tourist_bikes, :reward, foreign_key: true
  end
end
