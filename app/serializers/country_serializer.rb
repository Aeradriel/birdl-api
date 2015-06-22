class CountrySerializer < ActiveModel::Serializer
  attributes :id, :name, :language, :i18n_key, :available
end
