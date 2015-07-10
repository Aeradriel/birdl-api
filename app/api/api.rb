class API < Grape::API
  prefix 'api'

  format :json
  formatter :json, Grape::Formatter::ActiveModelSerializers

  helpers AuthHelper
  helpers ApplicationHelper

  before do
    unless no_auth_needed?
      authenticate!
    end
  end

  mount AuthAPI
  mount UserAPI
  mount EventAPI
  mount CountryAPI
  mount MessageAPI

  add_swagger_documentation base_path: '',
                            api_version: '1.0',
                            hide_documentation_path: true
end
