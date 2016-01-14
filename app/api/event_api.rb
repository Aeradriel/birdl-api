# Class that handle API endpoints for events
class EventAPI < Grape::API
  include EventHelper

  desc 'Get all events'
  get '/events', each_serializer: EventSerializer do
    filter_events (Event.all)
  end

  desc 'Get past events'
  get '/events/past', each_serializer: EventSerializer, root: 'events' do
    filter_events(Event.where('date <= ?', Time.now))
  end

  desc 'Get future events'
  get '/events/future', each_serializer: EventSerializer, root: 'events' do
    filter_events(Event.where('date > ?', Time.now))
  end

  desc 'Get an event details'
  get '/events', serializer: EventSerializer do
    Event.where(id: params[:event_id]).first
  end

  desc 'Check if event includes user'
  get '/events/check' do
    error!('Missing param "event_id"', 400) unless params[:event_id]
    event = Event.where(id: params[:event_id].to_i).first
    error!('Wrong event id', 400) unless event
    user = User.where(id: params[:user_id].to_i).first if params[:user_id]
    user ||= @current_user
    event.users.include?(user)
  end

  desc 'Creates an event'
  post '/events/create' do
    error!('Missing param "name"', 400) unless params[:name]
    error!('Missing param "desc"', 400) unless params[:desc]
    error!('Missing param "type"', 400) unless params[:type]
    error!('Missing param "min_slots"', 400) unless params[:min_slots]
    error!('Missing param "max_slots"', 400) unless params[:max_slots]
    error!('Missing param "date"', 400) unless params[:date]
    error!('Missing param "end"', 400) unless params[:end]
    error!('Invalid event type', 400) unless Event.type.include?(params[:type])

    e = Event.new(name: params[:name], desc: params[:desc], type: params[:type],
                  min_slots: params[:min_slots].to_i, max_slots: params[:max_slots].to_i,
                  language: params[:language], owner_id: @current_user.id, location: params[:location])
    begin
      e.date = Date.strptime(params[:date], '%Y/%m/%d')
      e.end = Date.strptime(params[:end], '%Y/%m/%d')
    rescue ArgumentError => err
      error!(err.to_s, 400)
    end
    if e.save
      e
    else
      error!(e.errors.messages, 400)
    end
  end

  desc 'Deletes an event'
  delete '/events' do
    error!('Missing param "id"', 400) unless params[:id]
    event = Event.where(id: params[:id].to_i).first
    error!('Wrong event id', 400) unless event
    if event.delete
      'ok'
    else
      error!(event.errors.messages, 400)
    end
  end

  desc 'Register current user to an event'
  post '/events/register/:id' do
    error!('Missing param "id"', 400) unless params[:id]
    event = Event.where(id: params[:id].to_i).first
    error!('Wrong event id', 400) unless event
    if can_register?(event, @current_user)
      event.users << @current_user
      if event.save
        Notification.create(user_id: event.owner.id, text: "#{@current_user.name} has joined your event \"#{event.name}\"")
        event
      else
        error!(event.errors.messages, 400)
      end
    else
      error!('You cannot register to this event', 400)
    end
  end

  desc 'Remove current user from event'
  post '/events/unregister/:id' do
    error!('Missing param "id"', 400) unless params[:id]
    event = Event.where(id: params[:id].to_i).first
    error!('Wrong event id', 400) unless event
    if event.users.include?(@current_user)
      event.users = event.users.reject { |u| u.id == @current_user.id }
      if event.save
        Notification.create(user_id: event.owner.id, text: "#{@current_user.name} has left your event \"#{event.name}\"")
        event
      else
        error!(event.errors.messages, 400)
      end
    else
      error!('You are not part of this event', 400)
    end
  end

  desc 'Validate or not the presence of a user for an event'
  post '/events/validate_presence/' do
    error!('Missing param "user_id"', 400) unless params[:user_id]
    error!('Missing param "event_id"', 400) unless params[:event_id]
    error!('Missing param "was_there"', 400) unless params[:was_there]
    event = Event.where(id: params[:event_id].to_i).first
    error!('Wrong event id', 400) unless event
    user = User.where(id: params[:user_id].to_i).first
    error!('Wrong user id', 400) unless user
    error!('You or the other user is not part of this event', 400) unless event.users.include?(@current_user) && event.users.include?(user)
    participation = Participation.where(user_id: user.id, event_id: event.id).first
    if participation.update(was_there: params[:was_there].to_i)
      participation
    else
      error!(participation.errors.messages, 400)
    end
  end
end
