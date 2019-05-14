class CreateTouristBikes < ActiveRecord::Migration[5.1]
  def change
    create_table :tourist_bikes do |t|
      t.references :bike, foreign_key: true, index: true
      t.references :tourist, index: true
      t.date :day
      t.timestamps
    end
  end
end
