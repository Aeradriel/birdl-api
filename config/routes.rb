Rails.application.routes.draw do
  mount API => '/'
  mount GrapeSwaggerRails::Engine => '/doc'

  devise_for :user, skip: [:sessions]
end