FactoryBot.define do
  factory :product, class: "Product" do
    sku { "111" }
    color { "black" }
  end
end