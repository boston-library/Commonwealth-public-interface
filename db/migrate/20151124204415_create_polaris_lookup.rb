class CreatePolarisLookup < ActiveRecord::Migration[4.2]
  def change
    create_table :polaris_lookups do |t|
      t.string :itemID
      t.string :bibID
      t.string :horizonID
      t.string :barcodeID
      t.string :archiveID
    end
    add_index :polaris_lookups, :itemID, unique: true
    add_index :polaris_lookups, :bibID, unique: true
    add_index :polaris_lookups, :horizonID, unique: true
    add_index :polaris_lookups, :barcodeID, unique: true
    add_index :polaris_lookups, :archiveID
  end
end
