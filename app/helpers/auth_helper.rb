module AuthHelper
  def no_auth_needed?
    CONFIG['routes_without_authentication'].include?(request.env['PATH_INFO'][/[^.]+/])
  end

  def authenticate!
    error!('Unauthorized. Invalid or expired token.', 401) unless current_user
  end

  def current_user
    token = ApiKey.where(access_token: request.headers['Access-Token']).first
    if token && !token.expired?
      @current_user = User.find(token.user_id)
    else
      false
    end
  end

  def check_user_pwd(password)
    return true if @current_user.valid_password?(password)
    false
  end

  def filter_events(events)
    ret = events
    ret = events.where('lower(name) LIKE ?', "%#{params[:name].downcase}%") if params[:name]
    ret = ret.reject { |e| e.remaining_slots < params[:remaining_slots].to_i } if params[:remaining_slots]
    ret = ret.where(type: params[:event_type]) if
        params[:event_type]
    ret
  end
end