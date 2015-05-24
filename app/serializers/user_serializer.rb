class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :first_name,
             :last_name, :gender, :country
end
