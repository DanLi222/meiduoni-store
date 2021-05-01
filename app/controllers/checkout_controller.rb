class CheckoutController < ApplicationController
  def checkout
    @current_cart = Cart.current_cart(current_user)
    initial_state = @current_cart.state
    @addresses = current_user.addresses if has_address?

    navigate

    @current_cart.reload
    @line_items = @current_cart.line_items
    @state = @current_cart.state

    if @state == "init"
      redirect_to cart_path(@current_cart)
    end
  end

  private 

  attr_accessor :current_cart

  def navigate
    case params['checkout_action']
      when 'go_back'
        current_cart.prev_state
      when 'start_checkout'
        unless params['line_items'].nil? 
          isUpdated = update_line_items && update_cart_total
          current_cart.next_state if isUpdated
        end
      when 'add_address'
        add_address
        current_cart.next_state
      when 'add_payment'
        add_payment
        current_cart.next_state
      when 'confirm_payment'
        confirm_payment
        current_cart.next_state
    end
  end

  def update_line_items
    begin
      cart_line_items = params['line_items']
    rescue => error
      Rails.logger.error error.message
      return
    end
    
    ActiveRecord::Base.transaction do
      cart_line_items.map do |item|
        line_item = LineItem.find(item['id'])
        raise 'Line Item does not belong here!!!!!' unless line_item.cart == current_cart 
        line_item.update!(quantity: item['quantity'])
      end
    end
  end

  def update_cart_total
    cart_subtotal = current_cart.line_items.map { |item| item.price * item.quantity }.sum
    current_cart.update(subtotal: cart_subtotal, total: cart_subtotal * 1.13)
  end

  def has_address?
    current_user && current_user.addresses.any?
  end

  def add_address
    shipping_address = Addresses::AddressUpdater.new(user: current_user, params: address_params).call
    current_cart.update(shipping_address_id: shipping_address.id)
  end

  def add_payment
    if params['provider'] == "paypal"
      payment = Payment.create(provider: 'paypal', payer_id: params['payer_id'], payment_id: params['payment_id'], token: params['token'], state: "pending", cart: current_cart)
      
      current_cart.reload
      # To be modified
      unless current_cart.payments.first.nil? 
        current_cart.payments.first.update(state: "cancelled")
      end

      current_cart.update(billing_address_id: current_cart.shipping_address_id, payment_id: payment.id)
    end
  end

  def confirm_payment
    token = Paypal::PaypalAuthenticator.new.call
    return if token.nil?

    payment = current_cart.payments
    headers = {
      Authorization: "Bearer #{token.access_token}",
      "Content-Type": "application/json"
    }
    body = {
        payer_id: payment.first.payer_id,
        transactions: [
        {
          amount:
          {
            total: current_cart.total,
            currency: 'CAD'
          }
        }]
    }
    result = HTTParty.post(
        "https://api-m.sandbox.paypal.com/v1/payments/payment/#{payment.first.payment_id}/execute",
        headers: headers,
        body: body.to_json
    )

    if result["state"] == "approved"
      current_cart.payment.first.update(state: "completed")
    end
  end

  private

  def address_params
    params.permit('user_id', 'first_name', 'last_name', 'email', 'phone_number', 'postal_code', 'country', 'street_address', 'apartment', 'city', 'province', 'default_address')
  end

end
