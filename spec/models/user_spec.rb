# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                 :bigint           not null, primary key
#  role_id            :bigint           default(3), not null
#  first_name         :string(50)       not null
#  last_name          :string(50)       not null
#  username           :string(30)       not null
#  email              :string(100)      not null
#  omniauth_provider  :string(120)
#  uid                :string(120)
#  encrypted_password :string(120)      not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
require_relative '../shared_examples/models/crud_operations'

RSpec.describe User do
  describe 'database columns' do
    it { is_expected.to have_db_column(:first_name).of_type(:string).with_options(null: false, limit: 50) }
    it { is_expected.to have_db_column(:last_name).of_type(:string).with_options(null: false, limit: 50) }
    it { is_expected.to have_db_column(:email).of_type(:string).with_options(null: false, limit: 100) }
    it { is_expected.to have_db_column(:username).of_type(:string).with_options(null: false, limit: 30) }
    it { is_expected.to have_db_column(:encrypted_password).of_type(:string).with_options(null: false, limit: 120) }
    it { is_expected.to have_db_column(:role_id).of_type(:integer).with_options(null: false) }
    it { is_expected.to have_db_column(:omniauth_provider).of_type(:string).with_options(null: true, limit: 120) }
    it { is_expected.to have_db_column(:uid).of_type(:string).with_options(null: true, limit: 120) }
  end

  describe 'attributes' do
    it { is_expected.to respond_to(:first_name) }
    it { is_expected.to respond_to(:last_name) }
    it { is_expected.to respond_to(:email) }
    it { is_expected.to respond_to(:username) }
    it { is_expected.to respond_to(:encrypted_password) }
    it { is_expected.to respond_to(:role_id) }
    it { is_expected.to respond_to(:omniauth_provider) }
    it { is_expected.to respond_to(:uid) }
  end

  describe 'validations' do
    let(:password) { Faker::Internet.password(min_length: 8, max_length: 20) }
    let!(:valid_user) { build(:user) }
    let(:invalid_attributes) { { first_name: '', last_name: '', email: nil, role_id: 'A' } }

    context 'when trying to save data' do
      it { is_expected.to validate_presence_of(:first_name).with_message("can't be blank") }
      it { is_expected.to validate_length_of(:first_name).is_at_least(1).is_at_most(50) }

      it { is_expected.to validate_presence_of(:last_name).with_message("can't be blank") }
      it { is_expected.to validate_length_of(:last_name).is_at_least(1).is_at_most(50) }

      it { is_expected.to validate_presence_of(:email).with_message("can't be blank") }
      it { is_expected.to validate_length_of(:email).is_at_least(5).is_at_most(100) }

      it { is_expected.to validate_presence_of(:username).with_message("can't be blank") }
      it { is_expected.to validate_length_of(:username).is_at_least(8).is_at_most(30) }

      it { is_expected.to validate_presence_of(:password).with_message("can't be blank") }
      it { is_expected.to validate_length_of(:password).is_at_least(8).is_at_most(20) }

      it { is_expected.to validate_presence_of(:password_confirmation).with_message("can't be blank") }
      it { is_expected.to validate_length_of(:password_confirmation).is_at_least(8).is_at_most(20) }
    end

    context 'when trying to save invalid data' do
      before do
        valid_user.password = password
        valid_user.password_confirmation = password
      end

      it 'is invalid with empty first_name' do
        valid_user.first_name = ''
        valid_user.save
        expect(valid_user.errors[:first_name]).to include("can't be blank")
      end

      it 'is invalid with first_name length less than 1' do
        valid_user.first_name = ''
        valid_user.save
        expect(valid_user.errors[:first_name]).to include('is too short (minimum is 1 character)')
      end

      it 'is invalid with empty last_name' do
        valid_user.last_name = ''
        valid_user.save
        expect(valid_user.errors[:last_name]).to include("can't be blank")
      end

      it 'is invalid with last_name length less than 1' do
        valid_user.last_name = ''
        valid_user.save
        expect(valid_user.errors[:last_name]).to include('is too short (minimum is 1 character)')
      end

      it 'is invalid with first_name length greater than 50' do
        valid_user.first_name = 'A' * 51
        valid_user.save
        expect(valid_user.errors[:first_name]).to include('is too long (maximum is 50 characters)')
      end

      it 'is invalid with last_name length greater than 50' do
        valid_user.last_name = 'A' * 51
        valid_user.save
        expect(valid_user.errors[:last_name]).to include('is too long (maximum is 50 characters)')
      end

      it 'is invalid with duplicate email' do
        create(:user, email: 'test@email.com')
        valid_user.email = 'test@email.com'
        valid_user.save
        expect(valid_user.errors[:email]).to include('has already been taken')
      end

      it 'is invalid with empty email' do
        valid_user.email = ''
        valid_user.save
        expect(valid_user.errors[:email]).to include("can't be blank")
      end

      it 'is invalid with email length greater than 100' do
        valid_user.email = 'A' * 101
        valid_user.save
        expect(valid_user.errors[:email]).to include('is too long (maximum is 100 characters)')
      end

      it 'is invalid with duplicate username' do
        create(:user, username: 'username1')
        valid_user.username = 'username1'
        valid_user.save
        expect(valid_user.errors[:username]).to include('has already been taken')
      end

      it 'is invalid with empty username' do
        valid_user.username = ''
        valid_user.save
        expect(valid_user.errors[:username]).to include("can't be blank")
      end

      it 'is invalid with email length greater than 30' do
        valid_user.username = 'A' * 31
        valid_user.save
        expect(valid_user.errors[:username]).to include('is too long (maximum is 30 characters)')
      end

      it 'is invalid with password length less than 8' do
        valid_user.password = 'pass'
        valid_user.password_confirmation = 'pass'
        valid_user.save
        expect(valid_user.errors[:password]).to include('is too short (minimum is 8 characters)')
      end

      it 'is invalid with password length greater than 20' do
        valid_user.password = 'A' * 21
        valid_user.save
        expect(valid_user.errors[:password]).to include('is too long (maximum is 20 characters)')
      end

      it 'is invalid with password_confirmation length less than 8' do
        valid_user.password_confirmation = 'pass'
        valid_user.save
        expect(valid_user.errors[:password_confirmation]).to include('is too short (minimum is 8 characters)')
      end

      it 'is invalid with password_confirmation length greater than 20' do
        valid_user.password_confirmation = 'A' * 21
        valid_user.save
        expect(valid_user.errors[:password_confirmation]).to include('is too long (maximum is 20 characters)')
      end

      it 'is invalid without role_id' do
        valid_user.role_id = nil
        valid_user.save
        expect(valid_user.errors[:role_id]).to include('is not a number')
      end

      it 'is invalid' do
        valid_user.assign_attributes(invalid_attributes)
        expect(valid_user).not_to be_valid
      end
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:role) }
    it { is_expected.to have_many(:tokens) }
  end

  describe '#encrypt_password' do
    let(:user) { create(:user, password: 'password', password_confirmation: 'password') }

    it 'encrypts the password' do
      expect(user.password_confirmation).not_to be_nil
    end
  end

  describe '#authenticate' do
    let(:user) { create(:user, password: 'password', password_confirmation: 'password') }

    it 'returns true for correct password' do
      expect(user.authenticate('password')).to be true
    end

    it 'returns false for incorrect password' do
      expect(user.authenticate('wrong_password')).to be false
    end
  end

  describe '#generate_authentication_token' do
    let(:user) { create(:user) }

    it 'generates an authentication token' do
      token = user.generate_authentication_token
      expect(token).not_to be_nil
    end
  end

  describe '#invalidate_authentication_token' do
    let(:user) { create(:user) }
    let(:authentication_token) { 'sample_token' }

    it 'invalidates the authentication token' do
      user.invalidate_authentication_token(authentication_token)
      expect(user.tokens.last.authentication_token).to eq(authentication_token)
    end
  end

  describe '.invalid_token?' do
    let(:user) { create(:user) }

    it 'returns true for invalid token' do
      create(:token, user:, authentication_token: 'sample_token')
      expect(user.invalid_token?('sample_token')).to be true
    end

    it 'returns false for valid token' do
      expect(user.invalid_token?('valid_token')).to be false
    end
  end

  describe 'CRUD operations' do
    it_behaves_like 'model crud operations', :user do
      def model = described_class
    end
  end
end
