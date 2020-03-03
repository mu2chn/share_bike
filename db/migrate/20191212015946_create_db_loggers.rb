class CreateDbLoggers < ActiveRecord::Migration[6.0]
  def change
    create_table :db_loggers do |t|
      t.text :comment
      t.timestamps
    end
  end
end
