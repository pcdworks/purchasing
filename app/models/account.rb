class Account < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :validatable and :omniauthable, :recoverable, :rememberable
  devise :ldap_authenticatable, :trackable, :omniauthable, omniauth_providers: %i[openid_connect]
  before_save :set_fields


  def self.from_omniauth(auth)
    #puts auth
    account = where(email: auth.info.email).first
    if account
      return account
    else
      name =  auth.extra.raw_info.name.split(' ')
      groups = auth.extra.raw_info.groups
      approver = groups.include?('approver')
      givenname = ""
      surname = ""
      initials = ""
      if name.length > 1
        givenname = name[0]
        surname = name[1]
        initials = name[0][0] + name[1][0]
      else
        givenname = name[0]
        initials = name[0][0]
      end
      return Account.create(
        {
          email: auth.info.email,
          password: Devise.friendly_token[0, 20],
          username: auth.extra.raw_info.preferred_username,
          givenname: givenname,
          surname: surname,
          initials: initials,
          approver: approver
        }
      )
    end
  end

  def to_s
    self.username
  end

  def entry
    self.ldap_entry
  end

  def groups
    if self.ldap_entry
      self.ldap_entry.memberof || []
    else
      []
    end
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
    unless entry.nil?
      self.surname = entry.sn[0]
      self.givenname = entry.givenname[0]
      self.initials = entry.initials[0]
      self.email = entry.mail[0]
      self.approver = self.in_group?('approver')
    end
  end

  def approver?
    self.approver
  end

  def validator?
    self.in_group?('validator')
  end
end
