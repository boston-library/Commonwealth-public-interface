class AddFolders < ActiveRecord::Migration
  def self.up
    create_table :folders do |t|
      t.string :title
      t.integer :user_id, :null=>false
      t.string :description
      t.timestamps
    end
  end

  def self.down
    drop_table :folders
  end
end
