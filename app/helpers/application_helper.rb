module ApplicationHelper
  def send_response(*args)
    if args.size == 1
      render nothing: true, status: args[0]
    elsif args.size == 2
      render text: args[1], status: args[0]
    end
  end
end
