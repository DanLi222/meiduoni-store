class Product < ApplicationRecord
  has_one :property

  after_create :create_properties

  DEFAULT_GENDER = "male"
  DEFAULT_COLOR = "black"
  DEFAULT_MATERIAL = "leather"
  DEFAULT_SEASON = "all"
  DEFAULT_PRICE = 0

  private
  def create_properties
    self.property = Property.create(
        gender: DEFAULT_GENDER,
        material: DEFAULT_MATERIAL,
        season: DEFAULT_SEASON,
        price: DEFAULT_PRICE
    )
  end
end
