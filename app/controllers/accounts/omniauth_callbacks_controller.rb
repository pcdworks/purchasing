class Accounts::OmniauthCallbacksController < Devise::OmniauthCallbacksController

    skip_before_action :verify_authenticity_token, only: :openid_connect

    def openid_connect
      @account = Account.from_omniauth(request.env["omniauth.auth"])
  
      if @account.persisted?
        sign_in_and_redirect @account, event: :authentication
        set_flash_message(:notice, :success, kind: "OpenID Connect") if is_navigational_format?
      else
        redirect_to new_account_registration_url
      end
    end
  
    def failure
      redirect_to root_path
    end
end