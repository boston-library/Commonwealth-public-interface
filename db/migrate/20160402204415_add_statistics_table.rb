class AddStatisticsTable < ActiveRecord::Migration[4.2]
  def change
    create_table :admin_statistics do |t|
      t.string :pid
      t.integer :views
      t.float :average_time
      t.float :total_time
      t.integer :exits
    end
    add_index :admin_statistics, :pid, unique: true
  end
end