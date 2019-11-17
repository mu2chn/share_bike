class AddDetailTrans < ActiveRecord::Migration[5.1]
  def change
    add_column :transactions, :capture_ticket, :string
    add_column :transactions, :capture_deposit, :string
    add_column :transactions, :refund_ticket, :string
    add_column :transactions, :refund_deposit, :string
    add_column :transactions, :voided_all, :boolean, default: false
    add_column :transactions, :voided_deposit, :boolean, default: false
    add_column :transactions, :valid_ticket, :boolean, default: false
    add_column :transactions, :re_authorization_id, :string
  end
end
