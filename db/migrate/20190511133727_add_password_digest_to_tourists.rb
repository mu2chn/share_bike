class AddPasswordDigestToTourists < ActiveRecord::Migration[5.1]
  def change
    add_column :tourists, :password_digest, :string
  end
end
