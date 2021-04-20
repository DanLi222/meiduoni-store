class SessionsController < Devise::SessionsController
  def destroy
    cookies["guest_uuid"] = nil
    super
  end

  def require_no_authentication
    return if current_user && current_user.guest
    super
  end
end