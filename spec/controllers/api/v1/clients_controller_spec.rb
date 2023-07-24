# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::ClientsController do
  include SerializerSupport
  include_context 'with authenticated user'

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    let(:client) { create(:client) }

    it 'returns a success response' do
      get :show, params: { id: client.id }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    # Note we do not validate the response body here, we do it in the serializer specs
    context 'with valid parameters' do
      let!(:params_one) do
        {
          client: {
            name: 'Client 1', description: 'Description 1', client_code: 'C000000001',
            configuration: create(:configuration).attributes
          }
        }
      end
      let!(:params_two) do
        {
          client: {
            name: 'Client 2', description: 'Description 2', client_code: 'C000000002',
            configuration: create(:configuration).attributes
          }
        }
      end

      before do
        post :create, params: params_one
      end

      it 'creates a new client' do
        expect do
          post :create, params: params_two
        end.to change(Client, :count).by(1)
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:created)
      end

      it 'returns a JSON response' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) { attributes_for(:client, name: nil) }

      before do
        post :create, params: { client: invalid_attributes }
      end

      it 'does not create a new client' do
        expect do
          post :create, params: { client: invalid_attributes }
        end.not_to change(Client, :count)
      end

      it 'returns a unprocessable_entity response' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns a JSON response' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end

      it 'returns a JSON response with errors' do
        expect(response.body).to match("can't be blank")
      end
    end
  end

  describe 'PUT #update' do
    let(:client) { create(:client) }
    let(:configuration) { create(:configuration, client:) }

    let(:new_attributes) { { description: 'Some client' } }

    before do
      put :update, params: { id: client.id, client: new_attributes }
    end

    context 'with valid parameters' do
      it 'returns a success response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns a JSON response' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end

      it 'updates the requested client' do
        client.reload
        expect(serialize(client)[:data][:attributes].slice(:description)).to eq(new_attributes)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_new_attributes) { attributes_for(:client, name: nil) }

      before do
        put :update, params: { id: client.id, client: invalid_new_attributes }
      end

      it 'returns a unprocessable_entity response' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns a JSON response' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end

      it 'returns a JSON response with errors' do
        expect(response.body).to match("can't be blank")
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:client) { create(:client) }

    it 'destroys the requested client' do
      expect do
        delete :destroy, params: { id: client.id }
      end.to change(Client, :count).by(-1)
    end

    it 'returns a JSON response with a success message' do
      delete :destroy, params: { id: client.id }
      expect(response.body).to match('Client deleted successfully')
    end
  end
end
