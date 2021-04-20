class ApplicationController < ActionController::Base
  def set_locale
    I18n.locale = params[:locale].to_sym
  end

  def authenticate
    if current_user.nil? && (cookies["guest_uuid"].nil? || cookies["guest_uuid"].empty?)
      current_user = User.new_guest
      cookies["guest_uuid"] = GuestIdentification.find_by(guest: current_user).uuid
    elsif !cookies["guest_uuid"].nil? && !cookies["guest_uuid"].empty?
      current_user = GuestIdentification.find_by(uuid: cookies["guest_uuid"]).guest
    end
    sign_in(current_user) if current_user
  end
end
