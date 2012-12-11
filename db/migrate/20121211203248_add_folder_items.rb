class AddFolderItems < ActiveRecord::Migration
  def self.up
    create_table :folder_items do |t|
      t.integer :folder_id
      t.string :document_id

      t.timestamps
    end

    add_index :folder_items, :folder_id
    add_index :folder_items, :document_id

  end

  def self.down
    drop_table :folder_items
  end
end
