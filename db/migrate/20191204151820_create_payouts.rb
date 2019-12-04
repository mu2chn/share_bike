class CreatePayouts < ActiveRecord::Migration[6.0]
  def change
    create_table :payouts do |t|
      t.integer :payout_version
      t.string :paid_id
      t.integer :amount
      t.string :currency
      t.references :user, foreign_key: true
      t.string :target_email
      t.boolean :manual_input, default: false
      t.boolean :complete_dump, default: false
      t.text :send_text
      t.text :detail
      t.timestamps
    end
  end
end
