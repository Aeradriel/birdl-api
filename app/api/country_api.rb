# Country API
class CountryAPI < Grape::API
  desc 'Get all countries'
  get '/countries', each_serializer: CountrySerializer do
    Country.all
  end
end
