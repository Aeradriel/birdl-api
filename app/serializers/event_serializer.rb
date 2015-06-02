class EventSerializer < ActiveModel::Serializer
  root :event
  attributes :id, :name, :type, :min_slots,
             :max_slots, :date, :end, :desc,
             :owner, :address, :language, :location
end
