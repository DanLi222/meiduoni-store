class Cart < ApplicationRecord
  belongs_to :user
  has_many :line_items
  scope :user_carts, -> (user) { where(user_id: user.id) }

  def self.current_cart(user)
    user_carts(user).last
  end
end
