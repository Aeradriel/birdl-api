# Event API
class EventAPI < Grape::API
  desc 'Get events list'
  get '/events', each_serializer: EventSerializer do
    Event.all
  end
end
