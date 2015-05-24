class EventSerializer < ActiveModel::Serializer
  attributes :id, :name, :type, :min_slots,
             :max_slots, :date, :end, :desc,
             :owner, :address, :language, :location
end
