class GuestIdentification < ApplicationRecord
  belongs_to :guest, :class_name => "User", :foreign_key => "guest_id"
  before_create :set_uuid

  private
  def set_uuid
    self.uuid = SecureRandom.uuid
  end

end
