FactoryBot.define do
  factory :line_item, class: "LineItem" do
    quantity { 1 }

    cart { create(:cart) }

    # user { create(:user) }
    
    factory :line_item_with_inventory do
      inventory { create(:inventory_with_product) }
    end
  end
end