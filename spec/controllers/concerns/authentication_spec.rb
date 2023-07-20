# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Authentication do
  include_context 'with dummy controller'
  include_context 'with authenticated user'

  describe 'Authentication concern' do
    let(:invalid_token) { 'invalid_token' }

    context 'with a valid token' do
      before do
        get :profile
      end

      it 'returns success status' do
        expect(response).to have_http_status(:ok)
      end

      it 'authenticates the user' do
        expect(assigns(:current_user)).to eq(current_user)
      end
    end

    context 'with an invalid token' do
      before do
        request.cookies['Authorization'] = invalid_token
        get :profile
      end

      it 'returns unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'do not authenticates the user' do
        expect(assigns(:current_user)).to be_nil
      end
    end

    context 'with no token' do
      before do
        request.cookies['Authorization'] = nil
        get :profile
      end

      it 'returns unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'do not authenticates the user' do
        expect(assigns(:current_user)).to be_nil
      end
    end
  end

  describe 'sign_in?' do
    context 'when cookies[:Authorization] is present' do
      it 'returns true' do
        expect(controller.sign_in?).to be true
      end
    end

    context 'when cookies[:Authorization] is nil' do
      it 'returns false' do
        request.cookies['Authorization'] = nil
        expect(controller.sign_in?).to be false
      end
    end
  end
end
