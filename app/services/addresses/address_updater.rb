module Addresses
  class AddressUpdater
    def initialize(user:, params:)
      @user = user
      @params = params
    end

    def call
      add_address
    end

    private

    attr_reader :user, :params

    def add_address
      existing_address || Address.create(params.merge('user_id': user.id))
    end

    def existing_address
      addresses = user.addresses
      exclude = %w(id created_at updated_at defaultAddress user_id)
      addresses.filter do |address|
        address_attributes = address.attributes.except(*exclude)
        address if address_attributes == params
      end.first
    end
  end
end