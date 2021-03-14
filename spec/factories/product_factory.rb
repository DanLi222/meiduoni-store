FactoryBot.define do
  factory :product, class: "Product" do
    sku { "111" }
    color { "black" }
  
    after(:create) do |product, evaluator|
      create(:property, product: product)
    end
  end
end