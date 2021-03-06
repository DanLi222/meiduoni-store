class CartsController < ApplicationController
  def show
    @cart = Cart.current_cart(current_user)
    @line_items = @cart.line_items
  end
end
