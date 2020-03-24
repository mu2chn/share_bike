class CreateParkings < ActiveRecord::Migration[6.0]
  def change
    create_table :parkings do |t|
      t.string :name
      t.float :lat
      t.float :lng
      t.text :description
      t.timestamps
    end
  end
end
