class LineItem < ApplicationRecord
  belongs_to :inventory
  belongs_to :cart

  def price
    self.inventory.product.property.price
  end
end
