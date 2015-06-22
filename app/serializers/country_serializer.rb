class CountrySerializer < ActiveModel::Serializer
  attributes :id, :name, :i18n_key, :available
end
