# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'welcome#index'

  namespace :api do
    namespace :v1 do
      resources :roles
      resources :clients
      resources :users
    end
  end
end
