class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def authenticate_user!
    redirect_to new_user_session_path, alert: "You need to login to access that page." unless user_signed_in?
  end
end
