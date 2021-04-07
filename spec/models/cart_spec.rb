require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe '#self.current_cart' do
    context 'when user is nil' do
      it 'creates a new cart without persisting' do
        expect { Cart.current_cart(nil) }.to change { Cart.count }.by(0)
      end
      it 'returns a cart object' do
        cart = Cart.current_cart(nil)
        expect(cart.class).to eq(Cart)
      end
    end

    context 'when user is not nil' do
      it 'returns the last cart of the user' do
        user = create(:user)

        cart = Cart.current_cart(user)

        expect(cart).to eql(user.carts.last)
      end
    end
  end

  describe '#next_state' do
    context 'when cart state is init' do
      context 'when cart has no line items' do
        it 'does not change cart state' do
          cart = create(:cart, state: "init")
          cart.next_state

          expect(cart.state).to eql("init")
        end
      end
      context 'when cart has at least one line item' do
        it 'changes cart state to shipping' do
          cart = create(:cart_with_line_item, state: "init")
          cart.next_state

          expect(cart.state).to eql("shipping")  
        end
      end
    end

    context 'when cart state is shipping' do
      context 'when shipping_address_id is nil' do
        it 'does not update cart state' do
          cart = create(:cart_with_line_item, state: "shipping")
          cart.next_state

          expect(cart.state).to eql("shipping")
        end
      end
      context 'when shipping_address_id is not nil' do
        it 'updates cart state to payment' do
          address = create(:address)
          cart = create(:cart_with_line_item, state: "shipping", shipping_address_id: address.id)
          
          cart.next_state

          expect(cart.state).to eql("payment")
        end
      end
    end

    context 'when cart state is payment' do
      context 'when billing_address_id is nil' do
        it 'does not update cart state' do
          address = create(:address)
          cart = create(:cart_with_line_item, state: "payment", shipping_address_id: address.id)
          
          cart.next_state

          expect(cart.state).to eql("payment")
        end
      end
      context 'when billing_address_id is not nil' do
        it 'updates cart state to review' do
          address = create(:address)
          cart = create(:cart_with_line_item, state: "payment", shipping_address_id: address.id, billing_address_id: address.id)
          cart.next_state
          expect(cart.state).to eql("review")
        end
      end
    end

    context 'when cart state is review' do
      context 'when payment state is not completed' do
        it 'updates cart state to summary' do
          address = create(:address)
          cart = create(:cart_with_line_item_and_payment, state: "review", shipping_address_id: address.id, billing_address_id: address.id)

          cart.next_state

          expect(cart.state).to eql("review")
        end
      end
      context 'when payment state is completed' do
        it 'updates cart state to summary' do
          address = create(:address)
          cart = create(:cart_with_line_item_and_payment, state: "review", shipping_address_id: address.id, billing_address_id: address.id)
          payment = cart.payments.first
          payment.update(state: "completed")

          cart.next_state

          expect(cart.state).to eql("summary")
        end
      end
    end
  end

  describe '#prev_state' do
    context 'when cart state is review' do
      it 'updates cart state to payment' do
        cart = create(:cart, state: "review")
        
        cart.prev_state

        expect(cart.state).to eql("payment")
      end
    end
    
    context 'when cart state is payment' do
      it 'upates cart state to shipping' do
        cart = create(:cart, state: "payment")
        
        cart.prev_state

        expect(cart.state).to eql("shipping")
      end
    end
    
    context 'when cart state is shipping' do
      it 'updates cart state to init' do
        cart = create(:cart, state: "shipping")
        
        cart.prev_state

        expect(cart.state).to eql("init")
      end
    end
  end
end