class ApplicationController < ActionController::Base
  before_action :authenticate_account!

  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render :text => exception, :status => 500
  end


  def after_sign_in_path_for(resource)
    requests_path
  end
end
