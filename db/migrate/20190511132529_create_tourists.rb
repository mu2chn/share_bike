class CreateTourists < ActiveRecord::Migration[5.1]
  def change
    create_table :tourists do |t|
      t.string :name
      t.string :nickname
      t.string :email
      t.integer :phmnumber
      t.string :address
      t.string :passport
      t.integer :terms, default: 0
      t.timestamps
    end
  end
end