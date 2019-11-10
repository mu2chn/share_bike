class CreateUserReviews < ActiveRecord::Migration[5.1]
  def change
    create_table :user_reviews do |t|
      t.references :user, foreign_key: true, index: true
      t.references :tourist_bike, foreign_key: true
      t.integer :rate
      t.text :comment
      t.timestamps
    end
  end
end
