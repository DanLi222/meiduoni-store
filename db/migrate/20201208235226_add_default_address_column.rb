class AddDefaultAddressColumn < ActiveRecord::Migration[6.0]
  def change
    add_column :addresses, :defaultAddress, :boolean, default: false
  end
end
