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

  mount UserAPI
  mount AuthAPI
end
