class Cart < ApplicationRecord
  belongs_to :user
  has_many :line_items
  scope :user_carts, -> (user) { where(user_id: user.id) }

  def self.current_cart(user)
    user_carts(user).last
  end

  def next_state
    if self.state.nil?
      if self.line_items.count > 0
        self.update(state: "shipping")
      end
    elsif self.state == "shipping"
      unless self.shipping_address_id.nil?
        self.update(state: "payment")
      end
    elsif self.state == "payment"
      unless self.billing_address_id.nil?
        self.update(state: "review")
      end
    end
  end
end
