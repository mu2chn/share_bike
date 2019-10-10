class AddColumnTouristBike < ActiveRecord::Migration[5.1]
  def change
    add_column :tourist_bikes, :order_id, :string
    add_column :tourist_bikes, :amount, :integer
    add_column :tourist_bikes, :paid_date, :datetime
    add_column :tourist_bikes, :authorization_id, :string
    add_column :tourist_bikes, :capture_id, :string
    add_column :tourists, :authenticated, :boolean
    add_column :tourists, :authenticate_url, :string
    add_column :tourists, :authenticate_expire, :datetime
    add_column :users, :authenticated, :boolean
    add_column :users, :authenticate_url, :string
    add_column :users, :authenticate_expire, :datetime
  end
end
