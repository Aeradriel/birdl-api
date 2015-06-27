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
end