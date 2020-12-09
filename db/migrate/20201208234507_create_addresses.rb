class CreateAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :addresses do |t|
      t.integer "user_id", null: false
      t.string :firstName
      t.string :lastName
      t.string :streetAddress
      t.string :apartment
      t.string :city
      t.string :province
      t.string :postalCode
      t.string :country
      t.string :phoneNumber

      t.index ["user_id"], name: "index_addresses_on_user_id"

      t.timestamps
    end
  end
end
