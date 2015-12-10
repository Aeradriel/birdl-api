# Notification API
class NotificationAPI < Grape::API
  desc 'Get notifications of the user'
  get '/notifications' do
    @current_user.notifications
  end
end
