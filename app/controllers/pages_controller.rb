class PagesController < ApplicationController
  skip_before_action :authenticate_account!
  def browsers
  end
end
