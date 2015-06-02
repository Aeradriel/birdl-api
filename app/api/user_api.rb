# User API
class UserAPI < Grape::API
  desc 'Get base user info'
  get '/me', serializer: UserSerializer do
    @current_user
  end

  desc 'Register a user'
  post '/register', serializer: UserSerializer do
    user_params = JSON.parse(params[:user])
    u = User.new(user_params)
    u.birthdate = Date.strptime(user_params['birthdate'], '%Y/%m/%d')
    if u.save
      u
    else
      error!(u.errors.messages, 401)
    end
  end
end
