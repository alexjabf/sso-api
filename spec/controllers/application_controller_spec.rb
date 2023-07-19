# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController do
  include_context 'with dummy controller'

  describe 'when the request rises ActiveRecord::RecordNotFound' do
    before do
      allow(controller).to receive(:show).and_raise(ActiveRecord::RecordNotFound)
      get :show, params: { id: 1 }
    end

    it 'returns a not found status' do
      expect(response).to have_http_status(:not_found)
    end

    it 'returns an error message' do
      expect(response.body).to match(/Record not found./)
    end
  end

  describe 'when the request rises ActionDispatch::Http::Parameters::ParseError' do
    let(:message) { 'Invalid request parameters. Please check your request.' }

    before do
      allow(controller).to receive(:show).and_raise(ActionDispatch::Http::Parameters::ParseError.new(message))
      get :show, params: { id: '#$%#@$^' }
    end

    it 'returns a bad request status' do
      expect(response).to have_http_status(:bad_request)
    end

    it 'returns an error message' do
      expect(response.body).to match(/message/)
    end
  end
end
