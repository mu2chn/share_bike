class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :nickname
      t.string :email
      t.boolean :temp_terms, default: false
      t.integer :terms, default: 0
      t.timestamps
    end
  end
end
