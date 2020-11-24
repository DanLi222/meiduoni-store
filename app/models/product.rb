class Product < ApplicationRecord
  has_one :property, dependent: :destroy
  has_many :inventories, dependent: :destroy

  after_create :create_properties

  DEFAULT_GENDER = "male"
  DEFAULT_MATERIAL = "leather"
  DEFAULT_SEASON = "all"
  DEFAULT_PRICE = 0
  DEFAULT_QUANTITY = 0
  SIZES = 35..40

  private
  def create_properties
    self.property = Property.create(
        gender: DEFAULT_GENDER,
        material: DEFAULT_MATERIAL,
        season: DEFAULT_SEASON,
        price: DEFAULT_PRICE
    )
  end

  def create_inventories
    SIZES.each do |size|
      self.inventories << Inventory.create(size: size, quantity: DEFAULT_QUANTITY)
    end
  end
end
