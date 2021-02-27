class CheckoutController < ApplicationController
  def checkout
    @current_cart = Cart.current_cart(current_user)
    initial_state = @current_cart.state

    if params['checkout_action'] == 'start_checkout'
      unless params['line_items'].nil? 
        isUpdated = update_line_items && update_cart_total
        move_next = true if isUpdated
      end
    end

    if params['checkout_action'] == 'add_address'
      add_address
      move_next = true
    end

    if params['checkout_action'] == 'add_payment'
      add_payment
      move_next = true
    end

    if params['checkout_action'] == 'confirm_payment'
      confirm_payment
      move_next = true
    end

    if params['prev'] == "true"
      @current_cart.prev_state
    end
    if move_next == true
      @current_cart.next_state
    end
    @current_cart.reload
    @line_items = @current_cart.line_items
    @state = @current_cart.state
    if @state == "init"
      redirect_to cart_path(@current_cart)
    end
  end

  def update_line_items
    cart_line_items = params['line_items']
    result = cart_line_items.map do |item|
      params_line_item = JSON.parse(item)
      line_item = @current_cart.line_items.filter { |li| li.id == params_line_item["id"] }.first
      line_item.update(quantity: params_line_item["quantity"])
    end
    !result.include?(false) 
  end

  def update_cart_total
    cart_subtotal = @current_cart.line_items.map { |item| item.price * item.quantity }.sum
    @current_cart.update(subtotal: cart_subtotal, total: cart_subtotal * 1.13)
  end

  def add_address
    @address = Address.new(
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

  def add_payment
    if params['provider'] == "paypal"
      payment = Payment.create(provider: 'paypal', payer_id: params['payer_id'], payment_id: params['payment_id'], token: params['token'], state: "pending")
      
      unless @current_cart.payment.nil? 
        @current_cart.payment.update(state: "cancelled")
      end

      @current_cart.update(billing_address_id: @current_cart.shipping_address_id, payment_id: payment.id)
    end
  end

  def confirm_payment
    token = Paypal::PaypalAuthenticator.new.call
    return if token.nil?
    
    payment = @current_cart.payment
    headers = {
      Authorization: "Bearer #{token.access_token}",
      "Content-Type": "application/json"
    }
    body = {
        payer_id: payment.payer_id,
        transactions: [
        {
          amount:
          {
            total: @current_cart.total,
            currency: 'CAD'
          }
        }]
    }
    result = HTTParty.post(
        "https://api-m.sandbox.paypal.com/v1/payments/payment/#{payment.payment_id}/execute",
        headers: headers,
        body: body.to_json
    )

    if result["state"] == "approved"
      @current_cart.payment.update(state: "completed")
    end
  end
end
