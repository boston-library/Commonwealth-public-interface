class AddVisibilityToBpluserFolders < ActiveRecord::Migration
  def change
    add_column :bpluser_folders, :visibility, :string
  end
end
