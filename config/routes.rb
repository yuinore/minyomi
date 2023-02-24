# frozen_string_literal: true

Rails.application.routes.draw do
  get 'root', to: 'root#index'

  # Defines the root path route ("/")
  root "root#index"
end
