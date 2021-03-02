class User < ApplicationRecord
  has_many :carts, dependent: :destroy
  has_many :addresses
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_create :create_carts

  private
  def create_carts
    self.carts << Cart.create()
  end
end
