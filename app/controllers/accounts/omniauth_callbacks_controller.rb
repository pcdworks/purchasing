class Accounts::OmniauthCallbacksController < Devise::OmniauthCallbacksController

    skip_before_action :verify_authenticity_token, only: :openid_connect

    def openid_connect
      @account = Account.from_omniauth(request.env["omniauth.auth"])
  
      if @account.persisted?
        sign_in_and_redirect @account, event: :authentication
      else
        redirect_to new_account_session_url
      end
    end
  
    def failure
      redirect_to root_path
    end
end