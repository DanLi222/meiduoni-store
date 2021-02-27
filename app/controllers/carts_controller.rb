class CartsController < ApplicationController
  def show
    @cart = Cart.current_cart(current_user)
    @line_items_array = @cart.line_items.map do |line_item|
      {
        id: line_item.id,
        image: line_item.inventory.product.image,
        sku: line_item.inventory.product.sku,
        price: line_item.inventory.product.property.price,
        quantity: line_item.quantity,
        size: line_item.inventory.size
      }
    end

    @subtotal = BigDecimal("0")
    @line_items_array.each do |line_item|
      @subtotal += line_item[:price] * line_item[:quantity]
    end
    @cart.update(total: @subtotal * BigDecimal("1.13"))
  end
end
