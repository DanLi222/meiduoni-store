class ApplicationController < ActionController::Base
  before_action :authenticate
 
  def set_locale
    I18n.locale = params[:locale].to_sym
  end

  def authenticate
    if current_user.nil? && cookies["guest_uuid"].nil?
      @current_user = User.new_guest
      cookies["guest_uuid"] = GuestIdentification.find_by(guest: @current_user).uuid
    elsif !cookies["guest_uuid"].nil?
      @current_user = GuestIdentification.find_by(uuid: cookies["guest_uuid"]).guest
    end
  end
end
