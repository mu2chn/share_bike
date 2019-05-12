class CreateBikes < ActiveRecord::Migration[5.1]
  def change
    create_table :bikes do |t|
      t.string :name
      t.references :user, foreign_key: true
      t.string :image
      t.string :vehicle_num
      t.string :security_area
      t.integer :security_num
      t.integer :status, default: 0
      t.text :details
      t.timestamps
    end
  end
end
