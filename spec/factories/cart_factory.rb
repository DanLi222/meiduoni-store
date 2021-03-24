FactoryBot.define do
  factory :cart, class: "Cart" do
    state { "init" }

    user { create(:user) } 

    factory :cart_with_line_item do
      after(:create) do |cart, evaluator|
        create_list(:line_item_with_inventory, 3, cart: cart)
      end
    end

    factory :cart_with_line_item_and_payment do
      after(:create) do |cart, evaluator|
        create_list(:line_item_with_inventory, 3, cart: cart)
        create(:payment, cart: cart)
      end
    end
  end
end