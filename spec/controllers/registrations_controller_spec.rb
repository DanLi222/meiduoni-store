require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do
  params = { user: { email: "user@example.org", password: "password", password_confirmation: "password" } }

  describe '#create' do
    context 'when cookies does not have guest_uuid' do
      it 'creates a user' do
        @request.env['devise.mapping'] = Devise.mappings[:user]
        
        expect { post :create, params: params }.to change { User.count }.by(1)
      end
    end

    context 'when cookies guest_uuid exists' do
      it 'does not create a user' do
        guest_identification = create(:guest_identification)
        @request.cookies["guest_uuid"] = guest_identification.uuid

        @request.env['devise.mapping'] = Devise.mappings[:user]
        
        expect { post :create, params: params }.to change { User.count }.by(0)
      end
    end
  end
end