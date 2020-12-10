class AddAddressColumn < ActiveRecord::Migration[6.0]
  def change
    add_column :carts, :shipping_address_id, :integer
    add_column :carts, :billing_address_id, :integer
  end
end
