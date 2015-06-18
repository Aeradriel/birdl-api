# Class that handle API endpoints for events
class EventAPI < Grape::API
    desc 'Get all events'
  get '/events', each_serializer: EventSerializer do
    Event.all
  end

  desc 'Get past events'
  get '/events/past', each_serializer: EventSerializer, root: 'events' do
    Event.where('date <= ?', Time.now)
  end

  desc 'Get future events'
  get '/events/future', each_serializer: EventSerializer, root: 'events' do
    Event.where('date > ?', Time.now)
  end

  desc 'Get an event details'
  get '/events/:id', serializer: EventSerializer do
    Event.where(id: params[:id]).first
  end
end
