require 'rails_helper'

RSpec.describe Admins::ProductsController, type: :controller do
  describe '#create' do
    it 'persists a product in database' do
      params = { product: { sku: 'test', color: 'black', image: fixture_file_upload('test.jpeg', 'image/png') } }

      allow(Cloudinary::Uploader).to receive(:upload).and_return( { secure_url: 'test_url' }.with_indifferent_access )

      expect { post :create, params: params }.to change { Product.count }.by(1)
      expect(Product.last.image).to eq('test_url')
    end
  end

  describe '#update' do
    it 'udpates the product' do
      product = create(:product)
      params = { id: product.id, product: { sku: 'test', color: 'black', image: fixture_file_upload('test.jpeg', 'image/png') } }

      allow(Cloudinary::Uploader).to receive(:upload).and_return( { secure_url: 'test_url' }.with_indifferent_access )

      expect { post :update, params: params}.to change { Product.count }.by(0)
      updated_product = Product.find(product.id)
      expect(updated_product.image).to eq('test_url')
    end
  end

  describe '#destroy' do
    it 'remove a product from database' do
      product = create(:product)
      params = { id: product.id }

      expect { post :destroy, params: params }.to change { Product.count }.by(-1)
    end
  end
end