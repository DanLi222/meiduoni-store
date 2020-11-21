class CreateProperties < ActiveRecord::Migration[6.0]
  def change
    create_table :properties do |t|
      t.string :gender
      t.string :material
      t.string :season
      t.integer :price
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
