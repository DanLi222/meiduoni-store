require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#self.new_guest' do
    it 'creates a user' do
      expect { User.new_guest }.to change { User.count }.by(1)
    end
    it 'creates a user where column guest is true' do
      guest = User.new_guest

      expect(guest.guest).to eql(true)
    end
    it 'creates a guest identification' do
      expect { User.new_guest }.to change { GuestIdentification.count }.by(1)
    end
  end

  describe '#create_carts' do
    it 'creates a cart' do
      user = create(:user)

      expect { user.send :create_carts }.to change { Cart.count }.by(1)
    end
    it 'adds the created cart to self' do
      user = create(:user)

      expect { user.send :create_carts }.to change { user.carts.count }.by(1)
    end
  end

  describe '#self.create_guest_identification' do
    it 'creates a guest identification' do
      guest = create(:user)

      expect { User.create_guest_identification(guest) }.to change { GuestIdentification.count }.by(1)
    end
    it 'creates a guest identification based on the given guest' do
      guest = create(:user)
      guest_identification = User.create_guest_identification(guest)

      expect(guest_identification.guest).to equal(guest)
    end
  end

  describe '#self.guest_number' do
    it 'calls rand' do
      number = 12345
      expect(User).to receive(:rand).and_return(number)

      expect(User.guest_number).to eql(number)
    end
  end
end