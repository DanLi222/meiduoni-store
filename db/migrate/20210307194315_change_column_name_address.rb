class ChangeColumnNameAddress < ActiveRecord::Migration[6.0]
  def change
    rename_column :addresses, :streetAddress, :street_address
  end
end
