# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::RolesController do
  include SerializerSupport
  include_context 'with authenticated user'

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    let(:role) { create(:role) }

    it 'returns a success response' do
      get :show, params: { id: role.id }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    # Note we do not validate the response body here, we do it in the serializer specs
    context 'with valid parameters' do
      before do
        post :create, params: { role: attributes_for(:role) }
      end

      it 'creates a new role' do
        expect do
          post :create, params: { role: attributes_for(:role) }
        end.to change(Role, :count).by(1)
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:created)
      end

      it 'returns a JSON response' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) { attributes_for(:role, name: nil) }

      before do
        post :create, params: { role: invalid_attributes }
      end

      it 'does not create a new role' do
        expect do
          post :create, params: { role: invalid_attributes }
        end.not_to change(Role, :count)
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
    let(:role) { create(:role) }
    let(:new_attributes) { { name: 'Super Admin', description: 'Can manage everything' } }

    before do
      put :update, params: { id: role.id, role: new_attributes }
    end

    context 'with valid parameters' do
      it 'returns a success response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns a JSON response' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end

      it 'updates the requested role' do
        role.reload
        expect(serialize(role)[:data][:attributes].slice(:name, :description)).to eq(new_attributes)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_new_attributes) { attributes_for(:role, name: nil) }

      before do
        put :update, params: { id: role.id, role: invalid_new_attributes }
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
    let!(:role) { create(:role) }

    it 'destroys the requested role' do
      expect do
        delete :destroy, params: { id: role.id }
      end.to change(Role, :count).by(-1)
    end

    it 'returns a JSON response with a success message' do
      delete :destroy, params: { id: role.id }
      expect(response.body).to match('Role deleted successfully')
    end
  end
end
