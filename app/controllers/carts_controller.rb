class CartsController < ApplicationController
  before_action :authenticate

  def show
    @cart = Cart.current_cart(current_user)
    @line_items = @cart.line_items
  end
end
