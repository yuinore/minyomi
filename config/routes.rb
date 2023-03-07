# frozen_string_literal: true

Rails.application.routes.draw do
  # Defines the root path route ("/")
  root 'root#index'

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'logout', to: 'sessions#destroy', as: 'logout'

  resources :words, only: %i[index]
  resources :choices, only: %i[index create]
  resources :votes, only: %i[index]
  resources :profile, only: %i[index]

  get 'i/:slug', to: 'words#show', as: 'word'

  resources :sessions, only: %i[create destroy]
end
