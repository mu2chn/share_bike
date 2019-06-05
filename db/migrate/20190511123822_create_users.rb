class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :nickname
      t.string :email
      t.boolean :temp_terms, default: false
      t.integer :terms, default: 0
      t.integer :tutorial, default: 0
      t.string :remember_digest
      t.timestamps
    end
  end
end
