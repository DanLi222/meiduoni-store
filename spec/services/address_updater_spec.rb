require 'rails_helper'

RSpec.describe Addresses::AddressUpdater do
  existing_params = { 'first_name' => 'test_first', 'last_name' => 'test_second', 'email' => 'test@test.com', 'phone_number' => '123123123', 'postal_code' => 'code', 'country' => 'Canada', 'street_address' => 'test_street', 'apartment' => '', 'city' => 'test_city', 'province' => 'Ontario', 'default_address' => false }
  new_params = { 'first_name' => 'Dan', 'last_name' => 'Li', 'email' => 'anne.leedan@gmail.com', 'phone_number' => '8192132830', 'postal_code' => 'K2J5W8', 'country' => 'Canada', 'street_address' => '703 Egret Way', 'apartment' => '', 'city' => 'Ottawa', 'province' => 'Ontario' }


  describe '#existing_address' do
    context 'when the address already exists' do
      it 'returns the address' do
        user = create(:user)
        addresses = create_list(:address, 3, user_id: user.id)
        service = described_class.new(user: user, params: existing_params)

        expect(service.send :existing_address).to eq(addresses.first)
      end
    end

    context 'when the address does not exist' do
      it 'returns nil' do
        user = create(:user)
        addresses = create_list(:address, 3, user_id: user.id)
        service = described_class.new(user: user, params: new_params)
        
        expect(service.send :existing_address).to eq(nil)
      end
    end
  end

  describe '#add_address' do
    context 'when shipping address does not already exist' do
      it 'saves the address to database' do
        user = create(:user)
        addresses = create_list(:address, 3, user_id: user.id)
        service = described_class.new(user: user, params: new_params)
        
        expect { service.send :add_address }.to change { user.addresses.count }.by(1)
      end
    end

    context 'when shipping address already exist' do
      it 'does not save shipping address to database' do
        user = create(:user)
        addresses = create_list(:address, 3, user_id: user.id)
        service = described_class.new(user: user, params: existing_params)
        
        expect { service.send :add_address }.to change { user.addresses.count }.by(0)
      end
    end
  end

  describe '#call' do
    context 'when shipping address already exist' do
      it 'returns the shipping address without persisting it' do
        user = create(:user)
        addresses = create_list(:address, 3, user_id: user.id)
        service = described_class.new(user: user, params: existing_params)

        expect(service.call).to eq(addresses.first)
      end
    end

    context 'when shipping address does not already exist' do
      it 'saves the shipping address and returns it' do
        user = create(:user)
        addresses = create_list(:address, 3, user_id: user.id)
        service = described_class.new(user: user, params: new_params)

        new_address = service.call
        user.reload
        
        expect(new_address).to eq(user.addresses.last)
      end
    end
  end
end