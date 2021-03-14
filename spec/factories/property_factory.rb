FactoryBot.define do
  factory :property, class: "Property" do
    gender { "male" }
    material { "leather" }
    season { "spring" }
    price { "99.99" }
  end
end