class CreateAssetClasses < ActiveRecord::Migration[8.1]
  def change
    create_table :asset_classes do |t|
      t.string :name, null: false
      t.text :description
      t.timestamps
    end
    add_index :asset_classes, :name, unique: true
  end
end
