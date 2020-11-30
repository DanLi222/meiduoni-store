class LineItem < ApplicationRecord
  belongs_to :inventory
  belongs_to :cart
end
