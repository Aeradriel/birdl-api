# User API
class UserAPI < Grape::API
  desc 'Get base user info'
  get '/me', serializer: UserSerializer do
    @current_user
  end
end
