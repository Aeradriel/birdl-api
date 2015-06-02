# Event API
class EventAPI < Grape::API
  desc 'Get events list'
  get '/events', each_serializer: EventSerializer do
    Event.all
  end

  get '/events/past', each_serializer: EventSerializer, root: 'events' do
    Event.where('date <= ?', Time.now)
  end

  get '/events/future', each_serializer: EventSerializer, root: 'events' do
    Event.where('date > ?', Time.now)
  end
end
