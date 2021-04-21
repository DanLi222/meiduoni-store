class SessionsController < Devise::SessionsController
  def require_no_authentication
    return if current_user && current_user.guest
    super
  end
end