Rails.application.routes.draw do
  mount API => '/'

  devise_for :user, skip: [:sessions]
end