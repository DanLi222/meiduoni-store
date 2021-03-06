FactoryBot.define do
  factory :inventory, class: "Inventory" do
    size { "6" }
    quantity { 3 }

    factory :inventory_with_product do
      product { create(:product) }
    end
  end
end