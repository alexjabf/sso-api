# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WelcomeController do
  describe 'GET #index' do
    it 'returns success status' do
      expect(response).to have_http_status(:success)
    end

    it 'renders a JSON response' do
      get :index
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end

    it 'returns the welcome message' do
      get :index
      expect(response.body).to include('API Online!')
    end
  end
end
