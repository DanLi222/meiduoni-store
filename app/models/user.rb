class User < ApplicationRecord
  has_many :carts, dependent: :destroy
  has_many :addresses
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_create :create_carts

  def self.new_guest
    guest = create(email: "guest" + "#{guest_number}" + "@guest.com", password: SecureRandom.uuid, guest: true)
    create_guest_identification(guest)
    guest
  end

  private
  def create_carts
    self.carts << Cart.create()
  end

  def self.create_guest_identification(guest)
    GuestIdentification.create(guest: guest)
  end

  def self.guest_number
    where(:guest => true).count + 1
  end
end
