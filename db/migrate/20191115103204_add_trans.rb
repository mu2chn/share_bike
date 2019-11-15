class AddTrans < ActiveRecord::Migration[5.1]
  def change
    add_reference :tourist_bikes, :transaction,  foreign_key: true
  end
end
