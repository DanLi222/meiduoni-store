require 'rails_helper'

RSpec.describe CheckoutController, type: :controller do
  describe '#navigate' do
    context 'when passing previous page as param' do
      it 'updates current cart state to previous state' do
        cart = create(:cart, state: 'shipping')
        allow(controller).to receive(:current_cart).and_return(cart)

        controller.params[:checkout_action] = 'go_back'

        controller.send :navigate

        expect(cart.state).to eql('init')
      end
    end

    context 'when passing start check out as param' do
      it 'updates line item quantity' do
        cart = create(:cart_with_line_item, state: 'init')
        allow(controller).to receive(:current_cart).and_return(cart)

        controller.params[:checkout_action] = 'start_checkout'
        params = cart.line_items.map { |item| item.attributes.slice "id", "quantity" }
        params.first['quantity'] = 2
        controller.params[:line_items] = params

        controller.send :navigate

        expect(cart.line_items.first.quantity). to eql(2)
      end

      it ' updates current cart total' do
        cart = create(:cart_with_line_item, state: 'init')
        allow(controller).to receive(:current_cart).and_return(cart)

        controller.params[:checkout_action] = 'start_checkout'
        params = cart.line_items.map { |item| item.attributes.slice "id", "quantity" }
        params.first['quantity'] = 2
        controller.params[:line_items] = params

        expected_subtotal = cart.line_items.map { |item| item.price * item.quantity }.sum
        controller.send :navigate

        expect(cart.subtotal).to eql(expected_subtotal)
        expect(cart.total).to eql(expected_subtotal * 1.13)
      end

      it 'updates cart state to shipping' do
        cart = create(:cart_with_line_item, state: 'init')
        allow(controller).to receive(:current_cart).and_return(cart)

        controller.params[:checkout_action] = 'start_checkout'
        params = cart.line_items.map { |item| item.attributes.slice "id", "quantity" }
        params.first['quantity'] = 2
        controller.params[:line_items] = params
        
        controller.send :navigate

        expect(cart.state).to eql("shipping")
      end
    end

    context 'when passing add address as param' do
      it 'adds address to database if does not exist' do
        user = create(:user)
        allow(controller).to receive(:current_user).and_return(user)
        cart = create(:cart_with_line_item, state: 'shipping', user: user)
        allow(controller).to receive(:current_cart).and_return(cart)

        params = { 'first_name': 'test_first', 'last_name': 'test_second', 'street_address': 'test_street', 'apartment': '', 'city': 'test_city', 'province': 'Ontario', 'postal_code': 'code', 'country': 'Canada', 'phone_number': '123123123', 'email': 'test@test.com', 'default_address': false, 'checkout_action': 'add_address' }
        controller.params = params

        expect { controller.send :navigate }.to change { user.addresses.count }.by(1)
      end

      it 'add shipping address id to cart' do
        user = create(:user)
        allow(controller).to receive(:current_user).and_return(user)
        cart = create(:cart_with_line_item, state: 'shipping', user: user)
        allow(controller).to receive(:current_cart).and_return(cart)

        params = { 'first_name': 'test_first', 'last_name': 'test_second', 'street_address': 'test_street', 'apartment': '', 'city': 'test_city', 'province': 'Ontario', 'postal_code': 'code', 'country': 'Canada', 'phone_number': '123123123', 'email': 'test@test.com', 'default_address': false, 'checkout_action': 'add_address' }
        controller.params = params
        controller.send :navigate
        user.reload

        expect(cart.shipping_address_id).to eql(user.addresses.last.id)
      end

      it 'updates cart state to payment' do
        user = create(:user)
        allow(controller).to receive(:current_user).and_return(user)
        cart = create(:cart_with_line_item, state: 'shipping', user: user)
        allow(controller).to receive(:current_cart).and_return(cart)

        params = { 'first_name': 'test_first', 'last_name': 'test_second', 'street_address': 'test_street', 'apartment': '', 'city': 'test_city', 'province': 'Ontario', 'postal_code': 'code', 'country': 'Canada', 'phone_number': '123123123', 'email': 'test@test.com', 'default_address': false, 'checkout_action': 'add_address' }
        controller.params = params
        controller.send :navigate

        expect(cart.state).to eql("payment")
      end
    end
  end
end