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


    # var CLIENT =
    #         'AQaZ6wR1B_vutfrT3RFc3SsdHC8DiZLNlX9AcEk0_wdEpjVZ5-VsEM_QYbnBqi4ddHdl8Srn0_vghSKX';
    # var SECRET =
    #         'EPVPkuiANAR0DPoWiVuwtzsbbdQl_axBKHePCG0hYwroYP28AgexPVe2YQUxv4tiq8YSUIgru_cXcNMr';
    # var PAYPAL_API = 'https://api-m.sandbox.paypal.com';


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



# => {"id"=>"PAYID-L7PZ3AQ2KF35483161079812",
#  "intent"=>"sale",
#  "state"=>"approved",
#  "cart"=>"08X66534KY8032232",
#  "payer"=>
#   {"payment_method"=>"paypal",
#    "status"=>"VERIFIED",
#    "payer_info"=>
#     {"email"=>"sb-jz9zr4081648@personal.example.com",
#      "first_name"=>"John",
#      "last_name"=>"Doe",
#      "payer_id"=>"AGJZWCDWVAYK6",
#      "shipping_address"=>{"recipient_name"=>"John Doe", "line1"=>"1 Maire-Victorin", "city"=>"Toronto", "state"=>"ON", "postal_code"=>"M5A 1E1", "country_code"=>"CA"},
#      "country_code"=>"CA"}},
#  "transactions"=>
#   [{"amount"=>{"total"=>"10.99", "currency"=>"USD", "details"=>{"subtotal"=>"10.99", "shipping"=>"0.00", "insurance"=>"0.00", "handling_fee"=>"0.00", "shipping_discount"=>"0.00", "discount"=>"0.00"}},
#     "payee"=>{"merchant_id"=>"FX9SMNRNWKFP8", "email"=>"sb-fvfxw4082663@business.example.com"},
#     "item_list"=>{"shipping_address"=>{"recipient_name"=>"John Doe", "line1"=>"1 Maire-Victorin", "city"=>"Toronto", "state"=>"ON", "postal_code"=>"M5A 1E1", "country_code"=>"CA"}},
#     "related_resources"=>
#      [{"sale"=>
#         {"id"=>"6CH206939T7821027",
#          "state"=>"completed",
#          "amount"=>{"total"=>"10.99", "currency"=>"USD", "details"=>{"subtotal"=>"10.99", "shipping"=>"0.00", "insurance"=>"0.00", "handling_fee"=>"0.00", "shipping_discount"=>"0.00", "discount"=>"0.00"}},
#          "payment_mode"=>"INSTANT_TRANSFER",
#          "protection_eligibility"=>"ELIGIBLE",
#          "protection_eligibility_type"=>"ITEM_NOT_RECEIVED_ELIGIBLE,UNAUTHORIZED_PAYMENT_ELIGIBLE",
#          "transaction_fee"=>{"value"=>"0.62", "currency"=>"USD"},
#          "receivable_amount"=>{"value"=>"10.99", "currency"=>"USD"},
#          "exchange_rate"=>"0.735929839483399",
#          "parent_payment"=>"PAYID-L7PZ3AQ2KF35483161079812",
#          "create_time"=>"2020-12-20T18:53:26Z",
#          "update_time"=>"2020-12-20T18:53:26Z",
#          "links"=>
#           [{"href"=>"https://api.sandbox.paypal.com/v1/payments/sale/6CH206939T7821027", "rel"=>"self", "method"=>"GET"},
#            {"href"=>"https://api.sandbox.paypal.com/v1/payments/sale/6CH206939T7821027/refund", "rel"=>"refund", "method"=>"POST"},
#            {"href"=>"https://api.sandbox.paypal.com/v1/payments/payment/PAYID-L7PZ3AQ2KF35483161079812", "rel"=>"parent_payment", "method"=>"GET"}]}}]}],
#  "failed_transactions"=>[],
#  "create_time"=>"2020-12-20T18:52:50Z",
#  "update_time"=>"2020-12-20T18:53:26Z",
#  "links"=>[{"href"=>"https://api.sandbox.paypal.com/v1/payments/payment/PAYID-L7PZ3AQ2KF35483161079812", "rel"=>"self", "method"=>"GET"}]}