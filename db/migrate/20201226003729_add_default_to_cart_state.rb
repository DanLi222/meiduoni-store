class AddDefaultToCartState < ActiveRecord::Migration[6.0]
  def change
    change_column_default :carts, :state, "init"
  end
end
