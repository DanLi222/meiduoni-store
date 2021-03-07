require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  describe '#products' do
    it 'returns a list of products(containing two attributes) with the same sku' do
      products = create_list(:product, 3)
      invalid_product = products.last
      invalid_product.update(sku: 222)
      expected_products = products - [invalid_product]

      controller.instance_variable_set(:@selected_product, products.first)

      expect(controller.send :products).to eq(expected_products.pluck :color, :id)
    end
  end

  describe '#selected_product' do
    context 'when product_id exists' do
      it 'returns the product with id equals to product_id' do
        products = create_list(:product, 3)
        controller.params = { product_id: products.second.id, id: products.first.id }

        expect(controller.send :selected_product).to eq(products.second)
      end
    end

    context 'when product_id does not exist' do
      it 'returns the product with id equals to id' do
        products = create_list(:product, 3)
        controller.params = { id: products.first.id }

        expect(controller.send :selected_product).to eq(products.first)
      end
    end
  end
end