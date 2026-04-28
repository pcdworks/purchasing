class Account < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :validatable and :omniauthable, :recoverable, :rememberable
  devise :trackable, :omniauthable, omniauth_providers: %i[openid_connect]

  def self.from_omniauth(auth)
    account = where(email: auth.info.email).first
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

    if account
      account.givenname = givenname
      account.surname = surname
      account.initials = initials
      account.groups = groups
      account.approver = approver
      account.save!
      return account
    else
      return Account.create(
        {
          email: auth.info.email,
          username: auth.extra.raw_info.preferred_username,
          givenname: givenname,
          surname: surname,
          initials: initials,
          approver: approver,
          groups: groups
        }
      )
    end
  end

  def to_s
    self.username
  end

  def in_group?(group_name)
    self.groups.include?(group_name)
  end

  def approver?
    self.in_group?('approver')
  end

  def validator?
    self.in_group?('validator')
  end
end
