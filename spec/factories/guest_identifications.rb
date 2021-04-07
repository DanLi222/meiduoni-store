FactoryBot.define do
  factory :guest_identification do
    guest { create(:user) }
  end
end
