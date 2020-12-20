class CheckoutController < ApplicationController
  def checkout
    @current_cart = Cart.current_cart(current_user)
    if params['provider'] == "paypal"
      payment = Payment.create(provider: 'paypal', payer_id: params['PayerID'], payment_id: params['paymentId'], token: params['token'], state: "pending")
      unless @current_cart.payment.nil? 
        @current_cart.payment.update(state: "cancelled")
      end
      @current_cart.update(billing_address_id: @current_cart.shipping_address_id, payment_id: payment.id)
    end

    if params['confirm'] == 'true'
      payment = @current_cart.payment
      headers = {
        Authorization: "Bearer A21AAKlSJFztDn99rjzy9lfYiCN8S0tMCVJM8mNVg5XbNrcCAUzb7CVbKDQ2qYZMV_JboaKjWcrPk2SEJnWDH0UghOKtpbt_Q",
        "Content-Type": "application/json"
          # user: 'AQaZ6wR1B_vutfrT3RFc3SsdHC8DiZLNlX9AcEk0_wdEpjVZ5-VsEM_QYbnBqi4ddHdl8Srn0_vghSKX',
          # pass: 'EPVPkuiANAR0DPoWiVuwtzsbbdQl_axBKHePCG0hYwroYP28AgexPVe2YQUxv4tiq8YSUIgru_cXcNMr'
      }
      body = {
          payer_id: payment.payer_id,
          transactions: [
          {
            amount:
            {
              total: '10.99',
              currency: 'USD'
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
