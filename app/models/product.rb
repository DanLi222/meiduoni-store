class Product < ApplicationRecord
  has_one :property, dependent: :destroy
  has_many :inventories, dependent: :destroy

  after_create :create_properties, :create_inventories

  DEFAULT_GENDER = "male"
  DEFAULT_MATERIAL = "leather"
  DEFAULT_SEASON = "all"
  DEFAULT_PRICE = 0
  DEFAULT_QUANTITY = 0

  def sizes
    35..40
  end

  private
  def create_properties
    property = Property.create(
        gender: DEFAULT_GENDER,
        material: DEFAULT_MATERIAL,
        season: DEFAULT_SEASON,
        price: DEFAULT_PRICE
    )
  end

  def create_inventories
    sizes.each do |size|
      self.inventories << Inventory.create(size: size, quantity: DEFAULT_QUANTITY)
    end
  end
end
