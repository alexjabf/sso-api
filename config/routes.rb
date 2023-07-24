# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'welcome#index'

  namespace :api do
    namespace :v1 do
      resources :roles
      resources :clients do
        collection do
          get :search
          get :all
        end
      end
      resources :users
      post 'sign_up', to: 'registrations#sign_up'
      post 'login', to: 'sessions#login'
      delete 'logout', to: 'sessions#logout'
      get 'omniauth_callbacks/auth/:client_id', to: 'omniauth_callbacks#auth'
      post 'omniauth_callbacks/auth/:client_id', to: 'omniauth_callbacks#auth'
    end
  end
end
