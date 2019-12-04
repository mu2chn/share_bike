class AddRefer < ActiveRecord::Migration[6.0]
  def change
    add_reference :rewards, :payout, foreign_key: true
  end
end
