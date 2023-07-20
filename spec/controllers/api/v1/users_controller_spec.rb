# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::UsersController do
  include SerializerSupport

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    let(:user) { create(:user) }

    it 'returns a success response' do
      get :show, params: { id: user.id }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    let(:total_users) { User.count }

    # Note we do not validate the response body here, we do it in the serializer specs
    context 'with valid parameters' do
      let(:password) { Faker::Internet.password(min_length: 8, max_length: 20) }

      before do
        post :create,
             params: { user: build(:user).attributes.merge(password:, password_confirmation: password) }
      end

      it 'creates a new user' do
        expect do
          post :create,
               params: { user: build(:user).attributes.merge(password:, password_confirmation: password) }
        end.to change(User, :count).by(1)
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:created)
      end

      it 'returns a JSON response' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) { attributes_for(:user, first_name: nil) }

      before do
        post :create, params: { user: invalid_attributes }
      end

      it 'does not create a new user' do
        expect do
          post :create, params: { user: invalid_attributes }
        end.not_to change(User, :count)
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
    let(:user) { create(:user) }
    let(:new_attributes) { { first_name: 'Will', last_name: 'Smith' } }

    before do
      put :update, params: { id: user.id, user: new_attributes }
    end

    context 'with valid parameters' do
      it 'returns a success response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns a JSON response' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end

      it 'updates the requested user' do
        user.reload
        expect(serialize(user)[:data][:attributes].slice(:first_name, :last_name)).to eq(new_attributes)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_new_attributes) { attributes_for(:user, last_name: nil) }

      before do
        put :update, params: { id: user.id, user: invalid_new_attributes }
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
    let!(:user) { create(:user) }

    it 'destroys the requested user' do
      expect do
        delete :destroy, params: { id: user.id }
      end.to change(User, :count).by(-1)
    end

    it 'returns a JSON response with a success message' do
      delete :destroy, params: { id: user.id }
      expect(response.body).to match('User deleted successfully')
    end
  end
end
