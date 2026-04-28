class ApplicationController < ActionController::Base
  before_action :authenticate_account!

  def route_not_found
    render file: Rails.public_path.join('404.html'), status: :not_found, layout: false
  end

  def after_sign_in_path_for(resource)
    requests_path
  end
end
