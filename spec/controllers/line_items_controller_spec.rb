require 'rails_helper'

RSpec.describe LineItemsController, type: :controller do
  before do
    @user = create(:user)
    allow(controller).to receive(:current_user).and_return(@user)
  end

  describe '#add_to_cart' do
    context 'when line item exists in current cart' do
      it 'updates the quantity' do
        cart = create(:cart_with_line_item, user: @user)
        line_item = cart.line_items.first
        new_quantity = 2
        params = { inventory_id: line_item.inventory.id, quantity: new_quantity, cart_id: cart.id }
        
        expect do
          get :add_to_cart, :params => params, xhr: true
          line_item.reload
        end.to change { line_item.quantity }.by(new_quantity)
      end
    end

    context 'when line item does not exist' do
      it 'adds a line item to the current cart' do
        cart = create(:cart_with_line_item, user: @user)
        line_items = cart.line_items
        inventory = create(:inventory_with_product)
        params = { inventory_id: inventory.id, quantity: 2, cart_id: cart.id }
        
        expect { get :add_to_cart, :params => params, xhr: true }
         .to change { line_items.count }.by(1)
      end
    end
  end
end