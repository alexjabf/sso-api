# frozen_string_literal: true

# spec/models/concerns/omniauth_user_spec.rb

require 'rails_helper'

RSpec.describe OmniauthUser do
  let(:user_class) do
    Class.new do
      include OmniauthUser
    end
  end

  describe '.from_omniauth' do
    let(:user) { user_class.new }
    let(:resource_params) { { email: 'test@example.com', sub: '12345', custom_fields: { 'age' => 30 } } }
    let(:provider) { 'auth0' }

    context 'when email is present in resource_params' do
      let!(:existing_user) { create(:user, email: 'test@example.com') }

      it 'finds the user if already exists' do
        result, _status = user_class.from_omniauth({ email: 'test@example.com' }, 'auth0')
        expect(result.email).to eq(existing_user.email)
      end

      it 'returns user and status :ok if the user already exists' do
        _result, status = user_class.from_omniauth({ email: 'test@example.com' }, 'auth0')
        expect(status).to eq(:ok)
      end

      it 'creates a new user and returns the new user if the user does not exist' do
        resource_params = { first_name: 'New', last_name: 'User', email: 'new_user@example.com' }
        result, _status = user_class.from_omniauth(resource_params, 'auth0')
        expect(result.email).to eq('new_user@example.com')
      end
    end

    context 'when email is not present in resource_params' do
      let(:resource_params) { { sub: 'auth0' } }

      it 'returns nil' do
        result, = user_class.from_omniauth(resource_params, provider)
        expect(result).to be_nil
      end

      it 'returns :unprocessable_entity status' do
        _, status = user_class.from_omniauth(resource_params, provider)
        expect(status).to eq(:unprocessable_entity)
      end
    end
  end

  describe '.email_address' do
    let(:user) { user_class.new }

    it 'returns the email address if available in resource_params' do
      user_class.from_omniauth({ email: 'test@example.com' }, 'auth0')
      expect(user_class.email_address).to eq('test@example.com')
    end

    it 'returns the mail if available in resource_params' do
      user_class.from_omniauth({ mail: 'test@example.com' }, 'auth0')
      expect(user_class.email_address).to eq('test@example.com')
    end

    it 'returns the emailAddress if available in resource_params' do
      user_class.from_omniauth({ emailAddress: 'test@example.com' }, 'auth0')
      expect(user_class.email_address).to eq('test@example.com')
    end

    it 'returns the userPrincipalName if available in resource_params' do
      user_class.from_omniauth({ userPrincipalName: 'test@example.com' }, 'auth0')
      expect(user_class.email_address).to eq('test@example.com')
    end

    it 'returns nil if none of the email keys are available in resource_params' do
      user_class.from_omniauth({}, 'auth0')
      expect(user_class.email_address).to be_nil
    end
  end
end
