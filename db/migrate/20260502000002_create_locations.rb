class CreateLocations < ActiveRecord::Migration[8.1]
  def change
    create_table :locations do |t|
      t.string :plant_name, null: false
      t.string :address_line_1
      t.string :address_line_2
      t.string :suburb, null: false
      t.string :state
      t.text :notes
      t.timestamps
    end
  end
end
