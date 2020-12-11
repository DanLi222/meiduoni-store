class CheckoutController < ApplicationController
  def checkout
    @current_cart = Cart.current_cart(current_user)
    if params['prev'] == "true"
      @current_cart.prev_state
    end
    if params['prev'].nil?
      @current_cart.next_state
    end
    @current_cart.reload
    @line_items = @current_cart.line_items
    @total = @line_items.map{|item| item.inventory.product.property.price * item.quantity }.sum
    @state = @current_cart.state
  end

  def add_address
    @address = Address.create(
        firstName: params['firstName'],
        lastName: params['lastName'],
        email: params['email'],
        phoneNumber: params['phoneNumber'],
        postalCode: params['postalCode'],
        country: params['country'],
        streetAddress: params['streetAddress'],
        apartment: params['apartment'],
        city: params['city'],
        province: params['province'],
        user_id: current_user.id
    )
    if @address.save
      Cart.current_cart(current_user).update(shipping_address_id: @address.id)
    end
  end
end
