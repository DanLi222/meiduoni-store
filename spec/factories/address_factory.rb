FactoryBot.define do
  factory :address, class: "Address" do
    first_name { 'test_first' }
    last_name { 'test_second' }
    street_address { 'test_street' }
    apartment { '' }
    city { 'test_city' }
    province { 'Ontario' }
    postal_code { 'code' }
    country { 'Canada' }
    phone_number { '123123123' }
    email { 'test@test.com' }
    default_address { false }
  end
end