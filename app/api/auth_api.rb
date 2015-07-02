# Auth API
class AuthAPI < Grape::API
  desc 'Allow user to login'
  post '/login' do
    u = User.where(email: params[:email]).first

    if u && u.valid_password?(params[:password])
      token = ApiKey.create!(user_id: u.id)
      header('Access-Token', token.access_token)
      send_response('Authentication succeed')
    else
      error!('Authentication failed', 401)
    end
  end

  desc 'Check if token is valid'
  get '/check_token' do
  end
end
