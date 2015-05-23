module ApplicationHelper
  def send_response(*args)
    r = Response.new
    r.status = args[0]
    r.data = args[1]
    render json: r, status: r.status
  end
end
