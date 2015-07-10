class MessageSerializer < ActiveModel::Serializer
  root :message
  attributes :id, :sender_id, :receiver_id, :content
end
