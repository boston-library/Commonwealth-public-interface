class UserInstitutions < ActiveRecord::Migration
  def up
    create_table :institutions do |t|
      t.string :name
      t.string :pid
    end
    create_table :institutions_users, :id => false do |t|
      t.references :institution
      t.references :user
    end
    add_index :institutions_users, [:institution_id, :user_id]
    add_index :institutions_users, [:user_id, :institution_id]
  end

  def down
    drop_table :institutions_users
    drop_table :institutions
  end
end
