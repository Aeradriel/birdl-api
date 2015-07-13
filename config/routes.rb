Rails.application.routes.draw do
  mount API => '/'
  mount GrapeSwaggerRails::Engine => '/doc'

  devise_for :users, skip: [:sessions],
             controllers: {
                 registrations: 'users/registrations'
             }
end