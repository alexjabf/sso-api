# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::SessionsController do
  describe 'POST #login' do
    before do
      create(:user, email: 'test@example.com', password: 'FakePassword123', password_confirmation: 'FakePassword123')
    end

    context 'with valid credentials' do
      let(:valid_params) do
        {
          session: {
            email: 'test@example.com',
            password: 'FakePassword123'
          }
        }
      end

      before do
        post :login, params: valid_params
      end

      it 'returns success status' do
        expect(response).to have_http_status(:ok)
      end

      it 'creates an authentication_token' do
        parsed_response = response.parsed_body
        expect(parsed_response['data']['meta']['authentication_token']).not_to be_nil
      end

      it 'returns a json response' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context 'with invalid credentials' do
      let(:invalid_params) do
        {
          session: {
            email: 'test@example.com',
            password: 'IncorrectPassword123'
          }
        }
      end

      before do
        post :login, params: invalid_params
      end

      it 'returns unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'do not create an authentication_token' do
        parsed_response = response.parsed_body
        expect(parsed_response['authentication_token']).to be_nil
      end

      it 'returns a json response' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end

      it 'returns an error message' do
        parsed_response = response.parsed_body
        expect(parsed_response['error']).to eq('Invalid email or password')
      end
    end
  end

  describe 'DELETE #logout' do
    include_context 'with authenticated user'

    context 'when logout is successful' do
      before do
        delete :logout
      end

      it 'returns success status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns a json response' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end

      it 'returns a success message' do
        parsed_response = response.parsed_body
        expect(parsed_response['message']).to eq('Logged out successfully')
      end

      it 'invalidates the authentication token' do
        expect(current_user.tokens.count).to eq(1)
      end
    end

    context 'when logout fails' do
      before do
        request.cookies[:Authorization] = nil
        delete :logout
      end

      it 'returns unprocessable_entity status' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns a json response' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end

      it 'returns an error message' do
        parsed_response = response.parsed_body
        expect(parsed_response['data']['message']).to eq('Invalid authorization token.')
      end

      it 'do not invalidate the authentication token' do
        expect(current_user.tokens.count).to eq(0)
      end
    end
  end
end
