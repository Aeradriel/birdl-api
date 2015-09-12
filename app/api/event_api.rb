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
g
  desc 'Get future events'
  get '/events/future', each_serializer: EventSerializer, root: 'events' do
    filter_events(Event.where('date > ?', Time.now))
  end

  desc 'Get an event details'
  get '/event/:id', serializer: EventSerializer do
    Event.where(id: params[:id]).first
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

  desc 'Register current user to an event'
  post '/events/register/:id' do
    error!('Missing param "id"', 400) unless params[:id]
    event = Event.where(id: params[:id].to_i)
    error!('Wrong event id', 400) unless event
    if can_register?(event, @current_user)
      event.users << @current_user
      if event.save
        event
      else
        error!(event.errors.messages, 400) unless event
      end
    else
      error!('You cannot register to this event', 400)
    end
  end
end
