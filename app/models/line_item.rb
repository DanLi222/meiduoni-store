class LineItem < ApplicationRecord
  belongs_to :inventory
  belongs_to :cart

  def price
    self.inventory.product.property.price
  end

  def image
    self.inventory.product.image
  end

  def sku
    self.inventory.product.sku
  end

  def size
    self.inventory.size
  end

end
