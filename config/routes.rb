# frozen_string_literal: true

Rails.application.routes.draw do
  # Defines the root path route ("/")
  root "root#index"

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'logout', to: 'sessions#destroy', as: 'logout'

  resources :sessions, only: %i[create destroy]
end
