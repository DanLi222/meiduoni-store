class Inventory < ApplicationRecord
  belongs_to :product
  has_many :line_items
end
