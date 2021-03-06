FactoryBot.define do
  factory :user, class: "User" do
    sequence(:email) { |n| "test#{n}@example.com" }
    password { "test123" }
  end
end