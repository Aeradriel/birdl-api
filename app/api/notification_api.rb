# Notification API
class NotificationAPI < Grape::API
  desc 'Get notifications of the user'
  get '/notifications' do
    @current_user.notifications
  end

  put '/notifications' do
    @current_user.notifications.each do |n|
      if n.update(seen: true) == false
        error!('Could not update notification status', 500)
      end
    end
    'OK'
  end
end
