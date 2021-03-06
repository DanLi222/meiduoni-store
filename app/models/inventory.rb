class Inventory < ApplicationRecord
  belongs_to :product
  has_many :line_items

  scope :backordered, -> { where(quantity: 0) }
end
