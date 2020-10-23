class ChangePolarisLookupBarcodes < ActiveRecord::Migration[4.2]
  def change
    create_table :polaris_barcodes do |t|
      t.string :barcodeID
    end
    add_index :polaris_barcodes, :barcodeID, unique: true
    #add_foreign_key :polaris_barcodes, :polaris_lookups
    add_reference :polaris_barcodes, :polaris_lookup, index: true, foreign_key: true
  end
end