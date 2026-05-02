class CreateAssetClassCharacteristics < ActiveRecord::Migration[8.1]
  def change
    create_table :asset_class_characteristics do |t|
      t.references :asset_class, null: false, foreign_key: true
      t.references :characteristic, null: false, foreign_key: true
      t.boolean :required, null: false, default: false
      t.integer :display_order, null: false, default: 0
      t.timestamps
    end
    add_index :asset_class_characteristics, [:asset_class_id, :characteristic_id], unique: true, name: "index_acc_on_asset_class_and_characteristic"
  end
end
