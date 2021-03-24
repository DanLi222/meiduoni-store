class ChangeColumnName < ActiveRecord::Migration[6.0]
  def change
    rename_column :addresses, :firstName, :first_name
    rename_column :addresses, :lastName, :last_name
    rename_column :addresses, :postalCode, :postal_code
    rename_column :addresses, :phoneNumber, :phone_number
    rename_column :addresses, :defaultAddress, :default_address
  end
end
