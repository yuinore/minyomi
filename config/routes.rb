# frozen_string_literal: true

Rails.application.routes.draw do
  # Defines the root path route ("/")
  root 'root#index'

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'logout', to: 'sessions#destroy', as: 'logout'

  resources :words, only: [:index]
  resources :choices, only: [:index, :create]
  resources :votes, only: [:index create]
  resources :profile, only: [:index]

  get 'i/:slug', to: 'words#show', as: 'word'

  resources :sessions, only: [:create, :destroy]
end
