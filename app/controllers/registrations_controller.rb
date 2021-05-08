class RegistrationsController < Devise::RegistrationsController
  before_action :new_cart

  def create
    guest_uuid = cookies[:guest_uuid]
    guest_uuid.nil? || guest_uuid.empty? ? super : update_guest
  end

  private

  def update_guest
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)

    resource_updated = resource.update_without_password(account_update_params)
    resource.reset_password(account_update_params['password'], account_update_params['password'])

    if resource_updated
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
    resource.update(guest: false)
    guest_identification = GuestIdentification.find_by(uuid: cookies[:guest_uuid])
    cookies["guest_uuid"] = nil if guest_identification.delete
  end
end