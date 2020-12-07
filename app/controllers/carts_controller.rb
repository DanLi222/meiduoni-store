class CartsController < ApplicationController
  def show
    @cart = current_user.carts.last
    @line_items_array = @cart.line_items.map {
        |line_item| [line_item.inventory.product.image, line_item.inventory.product.sku, line_item.inventory.product.property.price, line_item.quantity, line_item.inventory.size]
    }

    @subtotal = BigDecimal("0")
    @line_items_array.each do |line_item|
      @subtotal += line_item[3] * line_item[2]
    end
    @total = @subtotal * BigDecimal("1.13")
  end
end
