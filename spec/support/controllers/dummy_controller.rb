# frozen_string_literal: true

RSpec.shared_context 'with dummy controller' do
  controller(ApplicationController) do
    include Authentication

    def profile
      authenticate_user!
      return unless sign_in?

      render json: { message: 'Authenticated' }, status: :ok
    end

    def index
      render json: { message: 'Rendering index' }, status: :ok
    end

    def show
      render json: { message: 'Rendering show' }, status: :ok
    end

    def create
      authenticate_user!
    end

    def update; end

    def destroy; end
  end

  before do
    # Mock the routes for the mocked dummy controller
    routes.draw do
      get 'profile', to: 'anonymous#profile'
      get 'index', to: 'anonymous#index'
      get 'show/:id', to: 'anonymous#show'
      post 'create', to: 'anonymous#create'
      put 'update/:id', to: 'anonymous#update'
      delete 'destroy/:id', to: 'anonymous#destroy'
    end
  end
end
