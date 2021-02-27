class AddSubtotalColumn < ActiveRecord::Migration[6.0]
  def change
    add_column :carts, :subtotal, :decimal, precision: 9, scale: 2
  end
end
