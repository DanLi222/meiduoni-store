require 'rails_helper'

RSpec.describe Product, type: :model do
  describe '#create_properties' do
    context 'when a product is created' do
      it 'creates a property object' do
        # product = Product.create!
        expect { Product.create! }.to change { Property.count }.by(1)
      end
    end
  end

  describe '#create_inventories' do
    context 'when a product is created' do
      it 'creates inventories' do
        expect { Product.create! }.to change { Inventory.count }.by(Product::SIZES.count)  
      end
    end
  end
end