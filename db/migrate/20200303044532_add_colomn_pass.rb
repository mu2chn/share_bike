class AddColomnPass < ActiveRecord::Migration[6.0]
  def change
    add_column :bikes, :pass, :integer
  end
end
