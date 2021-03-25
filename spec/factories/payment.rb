FactoryBot.define do
  factory :payment, class: "Payment" do
    provider { "paypal" }
    payer_id { "AGJZWCDWVAYK6" }
    payment_id { "PAYID-L7OSO7A2HY03991NS2215637" }
    token { "EC-0DY505669D2262518" }
    state { "pending" }
  end
end