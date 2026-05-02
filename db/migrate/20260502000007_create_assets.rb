class CreateAssets < ActiveRecord::Migration[8.1]
  def change
    create_table :assets do |t|
      t.string :asset_tag, null: false
      t.string :name, null: false
      t.references :asset_class, null: false, foreign_key: true
      t.references :location, null: false, foreign_key: true
      t.integer :parent_asset_id
      t.string :make
      t.string :model
      t.string :serial_number
      t.date :purchase_date
      t.decimal :purchase_cost, precision: 12, scale: 2
      t.date :installation_date
      t.string :status, null: false, default: "active"
      t.datetime :last_inspected_at
      t.timestamps
    end
    add_index :assets, :asset_tag, unique: true
    add_index :assets, :parent_asset_id
  end
end
