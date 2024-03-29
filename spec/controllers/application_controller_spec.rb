require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe '#current_user' do
    context 'when current user is not nil' do
      it 'does not create a user' do
        user = create(:user)
        allow(controller).to receive(:current_user).and_return(user)

        expect { controller.current_user }.to change { User.count }.by(0)
      end
      it 'does not create a guest identification' do
        user = create(:user)
        allow(controller).to receive(:current_user).and_return(user)

        expect { controller.current_user }.to change { GuestIdentification.count }.by(0)
      end
    end

    context 'when current user does not exist, but cookies["guest_uuid"] exists' do
      it 'does not create a user' do
        allow(controller).to receive(:current_user).and_return(nil)
        guest_identification = create(:guest_identification)
        @request.cookies["guest_uuid"] = guest_identification.uuid

        expect { controller.current_user }.to change { User.count }.by(0)
      end
      it 'set current user based on cookies["guest_uuid]' do
        guest_identification = create(:guest_identification)
        @request.cookies["guest_uuid"] = guest_identification.uuid
        user = controller.current_user

        expect(user).to eql(guest_identification.guest)
      end
    end

    context 'when current user and cookies[:guest_uuid] both do not exist' do
      it 'creates a guest' do
        expect { controller.current_user }.to change { User.count }.by(1)
      end
      it 'creates a guest identification' do
        expect { controller.current_user }.to change { GuestIdentification.count }.by(1)
      end
      it 'returns uuid' do        
        uuid = controller.current_user
        
        uuid.should_not be_nil
      end
    end
  end
end