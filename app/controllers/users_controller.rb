class UsersController < ApplicationController
  skip_before_filter :restrict_access, only: :auth

  include ApplicationHelper
  # Check if account exists with given credentials
  # If an account is found, return a token in header 'ACCESS-TOKEN'
  # If no account is found, return 401
  def auth
    u = User.where(email: params[:email]).first

    if u && u.valid_password?(params[:password])
      token = ApiKey.create!(user_id: u.id)
      response.headers['ACCESS-TOKEN'] = token.access_token
      send_response(200, 'Authentication succeed')
    else
      send_response(401, 'Authentication failed')
    end
  end

  def profile

  end
end