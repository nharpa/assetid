class CreateCharacteristics < ActiveRecord::Migration[8.1]
  def change
    create_table :characteristics do |t|
      t.string :name, null: false
      t.string :data_type, null: false
      t.text :description
      t.string :unit
      t.timestamps
    end
  end
end
