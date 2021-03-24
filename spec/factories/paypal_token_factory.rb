FactoryBot.define do
  factory :valid_paypal_token, class: "PaypalToken" do
    access_token { SecureRandom.uuid }
    expires_at { Time.now + 1.day }
  end

  factory :invalid_paypal_token, class: "PaypalToken" do
    access_token { SecureRandom.uuid }
    expires_at { Time.now - 1.day }
  end
end