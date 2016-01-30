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
      error!(u.errors.messages, 500)
    end
  end

  desc 'Get base user info'
  get '/me', serializer: UserSerializer do
    @current_user
  end

  desc 'Get user friends'
  get '/user/relations', each_serializer: UserSerializer do
    @current_user.all_friends
  end

  desc 'Add user to as friend'
  post '/user/relations', each_serializer: UserSerializer do
    error!('Missing param "user_id"', 400) if params[:user_id].nil?
    error!('Wrong param "user"', 400) unless User.where(id: params[:user_id].to_i).first
    @current_user.friends << User.where(id: params[:user_id].to_i).first
    if @current_user.save
      Notification.create(user_id: User.where(id: params[:user_id].to_i).first.id, subject: 'Nouvelle connaissance !', text: "#{@current_user.name} vous a ajouté en temps que connaissance")
      @current_user.all_friends
    else
      error!(@current_user.errors.messages, 500)
    end
  end

  desc 'Delete a user from friends'
  delete '/user/relations', each_serializer: UserSerializer do
    error!('Missing param "user_id"', 400) if params[:user_id].nil?
    user = User.where(id: params[:user_id].to_i).first
    error!('Wrong param "user"', 400) unless user
    rel = Relation.where(user_id: @current_user.id, friend_id: user.id).first
    rel ||= Relation.where(user_id: user.id, friend_id: @current_user.id).first
    error!('No such relation', 400) unless rel
    if rel.destroy
      @current_user.all_friends
    else
      error!(rel.errors.messages, 500)
    end
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
      error!(@current_user.errors.messages, 500)
    end
  end

  desc 'Rate user'
  post '/user/rate' do
    error!('Missing param "user_id"', 400) unless params[:user_id]
    error!('Missing param "event_id"', 400) unless params[:event_id]
    error!('Missing param "value"', 400) unless params[:value]
    user = User.where(id: params[:user_id].to_i).first
    error!('Wrong param "user_id"', 400) unless user
    event = Event.where(id: params[:event_id].to_i).first
    error!('Wrong param "event_id"', 400) unless event
    value = params[:value].to_i
    error!('You have already rated this user for this event', 400) if UserRating.where(event_id: event.id, giver_id: @current_user.id, user_id: user.id).first
    r = UserRating.new(event_id: event.id, giver_id: @current_user.id, user_id: user.id, value: value > 5 ? 5 : value)
    if r.save
      r
    else
      r.errors.messages
    end
  end

  desc 'User badges'
  get '/user/badges' do
    @current_user.badges
  end
end
