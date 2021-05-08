class CartsController < ApplicationController
  before_action :new_cart

  def show
    @cart = Cart.current_cart(current_user)
    @line_items = @cart.line_items
  end
end
