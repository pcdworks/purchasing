class Account < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :validatable and :omniauthable, :recoverable
  devise :ldap_authenticatable,
         :rememberable, :trackable
  before_create :set_fields

  def to_s
    self.username
  end

  def entry
    self.ldap_entry
  end

  def groups
    self.ldap_entry.memberof || []
  end

  def in_group?(group_name)
    group_name = 'cn=' + group_name + ','
    self.groups.each do |group|
      return true if group.start_with?(group_name)
    end
    false
  end

  def set_fields
    entry = self.entry
    self.surname = entry.sn[0]
    self.givenname = entry.givenname[0]
    self.initials = entry.initials[0]
    self.email = entry.mail[0]
  end
end
