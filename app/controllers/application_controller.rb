class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_filter :restrict_access

  def restrict_access
    authenticate_or_request_with_http_token do |token, _|
      token = ApiKey.where(access_token: token).first
      @current_user = token.user if token
    end
  end
end
