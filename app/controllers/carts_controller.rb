class CartsController < ApplicationController
  def show
    @cart = current_user.carts.last
    @line_items_array = @cart.line_items.map {
        |line_item| [line_item.inventory.product.image, line_item.inventory.product.sku, line_item.inventory.product.property.price, line_item.quantity, line_item.inventory.size]
    }
  end
end
