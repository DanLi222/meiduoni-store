class User < ApplicationRecord
  has_many :carts, dependent: :destroy
  has_many :addresses
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_create :create_cart

  def self.new_guest
    guest = create(email: "guest" + "#{guest_number}" + "@guest.com", password: SecureRandom.uuid, guest: true)
    if guest.errors.empty?
      create_guest_identification(guest)
      guest
    elsif guest.errors[:email] == ["has already been taken"] 
      new_guest
    end
  end

  def create_cart
    self.carts << Cart.create()
  end

  private

  def self.create_guest_identification(guest)
    GuestIdentification.create(guest: guest)
  end

  def self.guest_number
    rand(1e9)
  end
end
