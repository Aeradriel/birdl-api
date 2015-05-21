class UsersController < ApplicationController
  # Check for authentication
  include ApplicationHelper
  def email_pwd?
    u = User.where(email: params[:email]).first

    if u && u.valid_password?(params[:password])
      send_response(200, 'Authentication succeed')
    else
      send_response(401, 'Authentication failed')
    end
  end
end