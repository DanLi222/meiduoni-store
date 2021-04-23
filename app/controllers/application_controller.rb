class ApplicationController < ActionController::Base
  def set_locale
    I18n.locale = params[:locale].to_sym
  end

  def current_user
    super || current_guest
  end

  def current_guest
    if cookies["guest_uuid"].nil? || cookies["guest_uuid"].empty?
      guest = User.new_guest
      cookies["guest_uuid"] = GuestIdentification.find_by(guest: guest).uuid
    else
      guest = GuestIdentification.find_by(uuid: cookies["guest_uuid"]).guest
    end
    guest
  end
end
