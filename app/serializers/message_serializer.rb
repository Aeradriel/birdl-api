class MessageSerializer < ActiveModel::Serializer
  root :message
  attributes :id, :sender_id, :sender_name, :receiver_id, :receiver_name, :content

  def sender_name
    User.find(object.sender_id).name
  end

  def receiver_name
    User.find(object.receiver_id).name
  end
end
