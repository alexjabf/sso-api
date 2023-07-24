# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::RegistrationsController do
  include SerializerSupport

  describe 'POST #sign_up' do
    context 'with valid registration params' do
      let(:valid_params) do
        {
          registration: {
            first_name: 'Will',
            last_name: 'Smith',
            email: 'test@mail.com',
            username: 'username',
            password: 'FakePassword123',
            password_confirmation: 'FakePassword123',
            role_id: create(:role).id,
            client_id: create(:client).id
          }
        }
      end

      before do
        post :sign_up, params: valid_params
      end

      it 'returns success status' do
        expect(response).to have_http_status(:ok)
      end

      it 'creates a new user' do
        expect(User.count).to eq(1)
      end

      it 'returns a json response' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end

      it 'returns the serialized user' do
        parsed_response = response.parsed_body.deep_symbolize_keys!
        serialized_user = serialize(User.last).deep_symbolize_keys![:data][:attributes].except!(:created_at,
                                                                                                :updated_at)
        response_user = parsed_response[:data][:attributes].except!(:created_at, :updated_at)
        expect(response_user).to eq(serialized_user)
      end
    end

    context 'with invalid registration params' do
      let(:invalid_params) do
        {
          registration: {
            first_name: nil,
            last_name: '',
            email: 'invalid_email',
            role_id: 1
          }
        }
      end

      let(:expected_response) do
        {
          role: ['must exist'],
          client: ['must exist'],
          first_name: ["can't be blank", 'is too short (minimum is 1 character)'],
          last_name: ["can't be blank", 'is too short (minimum is 1 character)'],
          username: ["can't be blank", 'is too short (minimum is 8 characters)', 'is invalid'],
          password: ["can't be blank"],
          password_confirmation: ["can't be blank"],
          email: ['is invalid']
        }
      end

      before do
        post :sign_up, params: invalid_params
      end

      it 'returns unprocessable_entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not create a new user' do
        expect(User.count).to eq(0)
      end

      it 'returns a json response' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end

      it 'returns an error response' do
        parsed_response = response.parsed_body.deep_symbolize_keys
        expect(parsed_response[:data][:attributes][:errors]).to eq(expected_response)
      end
    end
  end
end
