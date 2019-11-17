class RemoveAttr < ActiveRecord::Migration[5.1]
  def change
    remove_columns :transactions, [:voided, :void, :refund, :capture_id]
    # remove_columns :tourist_bikes, [:amount, :paid_date, :authorization_id, :capture_id, :order_id]
  end
end
