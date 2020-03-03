class CreateRewards < ActiveRecord::Migration[6.0]
  def change
    create_table :rewards do |t|
      t.integer :amount
      t.string :currency
      t.references :user, foreign_key: true
      t.boolean :already_payout, default: false
      t.references :tourist_bike, foreign_key: true
      t.timestamps
    end
  end
end
