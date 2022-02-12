class Account < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :validatable and :omniauthable, :recoverable
  devise :ldap_authenticatable,
         :rememberable, :trackable

  def to_s
    self.username
  end
end
