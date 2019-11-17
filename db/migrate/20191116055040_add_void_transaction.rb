class AddVoidTransaction < ActiveRecord::Migration[5.1]
  def change
    add_column :transactions, :voided, :boolean
    add_column :transactions, :refund_id, :string
    add_column :transactions, :payer_id, :string
  end
end
