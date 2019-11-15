class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.string :order_id
      t.string :authorization_id
      t.string :capture_id
      t.references :tourist,  foreign_key: true
      t.boolean :void, default: false
      t.boolean :refunded, default: false
      t.integer :amount
      t.string :currency
      t.timestamps
    end
  end
end
