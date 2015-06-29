class EventSerializer < ActiveModel::Serializer
  root :event
  attributes :id, :name, :type, :min_slots,
             :max_slots, :date, :end, :desc,
             :owner_id, :address_id, :language, :location
end
