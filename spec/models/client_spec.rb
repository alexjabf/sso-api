# frozen_string_literal: true

# == Schema Information
#
# Table name: clients
#
#  id            :bigint           not null, primary key
#  name          :string(50)       not null
#  description   :text             not null
#  client_code   :string(50)       not null
#  custom_fields :jsonb            not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require_relative '../shared_examples/models/crud_operations'

RSpec.describe Client do
  describe 'database columns' do
    it { is_expected.to have_db_column(:name).of_type(:string).with_options(null: false, limit: 50) }
    it { is_expected.to have_db_column(:description).of_type(:text).with_options(null: false) }
    it { is_expected.to have_db_column(:client_code).of_type(:string).with_options(null: false, limit: 50) }
    it { is_expected.to have_db_column(:custom_fields).of_type(:jsonb) }
  end

  describe 'attributes' do
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:description) }
    it { is_expected.to respond_to(:client_code) }
    it { is_expected.to respond_to(:custom_fields) }
  end

  describe 'validations' do
    let!(:valid_client) { build(:client) }
    let(:invalid_attributes) { { name: '', description: '' } }

    context 'when trying to save data' do
      it { is_expected.to validate_presence_of(:name).with_message("can't be blank") }
      it { is_expected.to validate_length_of(:name).is_at_least(1).is_at_most(50) }

      it { is_expected.to validate_presence_of(:description).with_message("can't be blank") }
      it { is_expected.to validate_length_of(:description).is_at_least(1).is_at_most(5000) }

      it { is_expected.to validate_presence_of(:client_code).with_message("can't be blank") }
      it { is_expected.to validate_length_of(:client_code).is_at_least(10).is_at_most(50) }
    end

    context 'when trying to save invalid data' do
      it 'is invalid with empty name' do
        valid_client.name = ''
        valid_client.save
        expect(valid_client.errors[:name]).to include("can't be blank")
      end

      it 'is invalid with name length less than 1' do
        valid_client.name = ''
        valid_client.save
        expect(valid_client.errors[:name]).to include('is too short (minimum is 1 character)')
      end

      it 'is invalid with name length greater than 50' do
        valid_client.name = 'A' * 51
        valid_client.save
        expect(valid_client.errors[:name]).to include('is too long (maximum is 50 characters)')
      end

      it 'is invalid with empty description' do
        valid_client.description = ''
        valid_client.save
        expect(valid_client.errors[:description]).to include("can't be blank")
      end

      it 'is invalid with description length less than 1' do
        valid_client.description = ''
        valid_client.save
        expect(valid_client.errors[:description]).to include('is too short (minimum is 1 character)')
      end

      it 'is invalid with description length greater than 500' do
        valid_client.description = 'A' * 5001
        valid_client.save
        expect(valid_client.errors[:description]).to include('is too long (maximum is 5000 characters)')
      end

      it 'is invalid with empty client_code' do
        valid_client.client_code = ''
        valid_client.save
        expect(valid_client.errors[:client_code]).to include("can't be blank")
      end

      it 'is invalid with client_code length less than 1' do
        valid_client.client_code = ''
        valid_client.save
        expect(valid_client.errors[:client_code]).to include('is too short (minimum is 10 characters)')
      end

      it 'is invalid with client_code length greater than 50' do
        valid_client.client_code = 'A' * 51
        valid_client.save
        expect(valid_client.errors[:client_code]).to include('is too long (maximum is 50 characters)')
      end

      it 'is invalid with duplicate client_code' do
        create(:client, client_code: 'C000000001')
        valid_client.client_code = 'C000000001'
        valid_client.save
        expect(valid_client.errors[:client_code]).to include('has already been taken')
      end

      it 'is invalid' do
        valid_client.assign_attributes(invalid_attributes)
        expect(valid_client).not_to be_valid
      end
    end
  end

  describe 'CRUD operations' do
    it_behaves_like 'model crud operations', :client do
      def model = described_class
    end
  end
end
