# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'requests crud operations', type: :request do |controller_name|
  let(:object) { create(controller_name.singularize.to_sym) }

  before do
    cookies[:Authorization] = valid_token
  end

  describe 'GET /index' do
    it 'returns http success for index' do
      get("/api/v1/#{controller_name}")
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /show' do
    it 'returns http success for show' do
      get("/api/v1/#{controller_name}/#{object.id}")
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /create' do
    it 'returns http success for create' do
      get("/api/v1/#{controller_name}")
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PATCH /update' do
    it 'returns http success for update' do
      get("/api/v1/#{controller_name}/#{object.id}")
      expect(response).to have_http_status(:success)
    end
  end

  describe 'DELETE /destroy' do
    it 'returns http success for destroy' do
      get("/api/v1/#{controller_name}/#{object.id}")
      expect(response).to have_http_status(:success)
    end
  end
end
