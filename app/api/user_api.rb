# User API
class UserAPI < Grape::API
  include AuthHelper

  desc 'Register a user'
  post '/register', serializer: UserSerializer do
    error!('Missing param "user"', 400) if params[:user].nil?
    user_params = JSON.parse(params[:user])
    u = User.new(user_params)
    u.birthdate = Date.strptime(user_params['birthdate'], '%Y/%m/%d')
    if u.save
      u
    else
      error!(u.errors.messages, 400)
    end
  end

  desc 'Get base user info'
  get '/me', serializer: UserSerializer do
    @current_user
  end

  desc 'Update current user'
  post '/me', serializer: UserSerializer do
    error!('Missing param "user"', 400) unless params[:user]
    error!('Wrong password', 401) unless check_user_pwd(params[:password])
    user_params = JSON.parse(params[:user])
    user_params.delete('email') if @current_user.email == user_params['email']
    puts user_params
    @current_user.assign_attributes(user_params)
    @current_user.birthdate = Date.strptime(user_params['birthdate'], '%Y/%m/%d') if user_params['birthdate']
    if @current_user.save
      @current_user
    else
      error!(@current_user.errors.messages, 400)
    end
  end
end
