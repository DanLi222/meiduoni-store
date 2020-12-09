class AddressesController < ApplicationController
  def new
    @current_cart = Cart.current_cart(current_user)
    @line_items = @current_cart.line_items
    @total = @line_items.map{|item| item.inventory.product.property.price * item.quantity }.sum
  end
end
