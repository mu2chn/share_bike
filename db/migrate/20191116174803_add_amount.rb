class AddAmount < ActiveRecord::Migration[5.1]
  def change
    add_column :transactions, :ticket_amount, :integer
    add_column :transactions, :deposit_amount, :integer
  end
end
