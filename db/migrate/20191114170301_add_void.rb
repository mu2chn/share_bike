class AddVoid < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :void, :boolean, :default => false
    add_column :tourists, :void, :boolean, :default => false
    add_column :tourist_bikes, :void, :boolean, :default => false
    add_column :bikes, :void, :boolean, :default => false
  end
end
