# Message API
class MessageAPI < Grape::API
  desc 'Get all messages of user'
  get '/messages', each_serializer: MessageSerializer do
    error!('Missing param "relation"', 400) if params[:relation].nil?
    messages = @current_user.received_messages.where(
        sender_id: params[:relation].to_i) +
        @current_user.sent_messages.where(receiver_id: params[:relation].to_i)
    messages.sort! { |a, b| a.created_at <=> b.created_at }
    messages.uniq
  end

  desc 'Get sent messages to user'
  get '/messages/sent' do
    messages = Message.where(sender_id: @current_user.id, receiver_id: params[:sender_id])
    messages
  end

  desc 'Get received messages from user'
  get '/messages/received' do
    messages = Message.where(sender_id: params[:sender_id], receiver_id: @current_user.id)
    messages
  end

  desc 'Get all relations of user (the id)'
  get '/messages/relations' do
    relations = []
    @current_user.received_messages.select(:sender_id).each do |m|
      relations << { id: m.sender_id, name: User.find(m.sender_id).name }
    end
    @current_user.sent_messages.select(:receiver_id).each do |m|
      relations << { id: m.receiver_id, name: User.find(m.receiver_id).name }
    end
    relations.uniq
  end

  desc 'Create a message'
  post 'messages/new' do
    error!('Missing sender_id parameter', 400) unless params[:sender_id]
    error!('Missing receiver_id parameter', 400) unless params[:receiver_id]
    error!('Missing content parameter', 400) unless params[:content]
    error!("Unable to retrieve user with id #{params[:sender_id]}", 400) unless User.where(id: params[:sender_id]).count > 0
    error!("Unable to retrieve user with id #{params[:receiver_id]}", 400) unless User.where(id: params[:receiver_id]).count > 0
    m = Message.new(sender_id: params[:sender_id],
                    receiver_id: params[:receiver_id],
                    content: params[:content])
    if m.save
      m
    else
      error!(m.errors.messages, 400)
    end
  end
end
