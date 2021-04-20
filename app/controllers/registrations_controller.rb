class RegistrationsController < Devise::RegistrationsController  
  def create
    guest_uuid = cookies[:guest_uuid]
    guest_uuid.nil? ? super.create : update_guest
  end

  def update_guest
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)

    resource_updated = resource.update_without_password(account_update_params)

    if resource_updated
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
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
  end

  def require_no_authentication
    return if current_user && current_user.guest
    super
  end
end