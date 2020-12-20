class Payment < ApplicationRecord
    has_one :cart
end