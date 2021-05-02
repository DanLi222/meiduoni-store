class ApplicationController < ActionController::Base
  before_action :set_locale

  def set_locale
    I18n.locale = params[:locale].to_sym if params[:locale].present?
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

  def default_url_options
    { locale: I18n.locale }
  end
end
