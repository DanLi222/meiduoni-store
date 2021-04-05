class Cart < ApplicationRecord
  belongs_to :user
  has_many :payments
  has_many :line_items
  scope :user_carts, -> (user) { where(user: user) }

  def self.current_cart(user)
    user.nil? ? Cart.new : user_carts(user).last
  end

  def next_state
    self.reload
    case self.state
    when "init"
      if self.line_items.count > 0
        self.update(state: "shipping")
      end
    when "shipping"
      unless self.shipping_address_id.nil?
        self.update(state: "payment")
      end
    when "payment"
      unless self.billing_address_id.nil?
        self.update(state: "review")
      end
    when "review"
      if self.payments.first.state == "completed"
        self.update(state: "summary")
      end
    end 
    
  end

  def prev_state
    if self.state == "review"
      self.update(state: "payment")
    elsif self.state == "payment"
      self.update(state: "shipping")
    elsif self.state == "shipping"
      self.update(state: "init")
    end
  end
end
