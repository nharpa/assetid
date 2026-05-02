class CreateAssetCharacteristicValues < ActiveRecord::Migration[8.1]
  def change
    create_table :asset_characteristic_values do |t|
      t.references :asset, null: false, foreign_key: true
      t.references :asset_class_characteristic, null: false, foreign_key: true
      t.string :value, null: false
      t.timestamps
    end
    add_index :asset_characteristic_values, [:asset_id, :asset_class_characteristic_id], unique: true, name: "index_acv_on_asset_and_acc"
  end
end
