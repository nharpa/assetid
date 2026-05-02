class CreateCharacteristicAllowedValues < ActiveRecord::Migration[8.1]
  def change
    create_table :characteristic_allowed_values do |t|
      t.references :characteristic, null: false, foreign_key: true
      t.string :value, null: false
      t.timestamps
    end
  end
end
