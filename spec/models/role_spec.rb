# frozen_string_literal: true

# == Schema Information
#
# Table name: roles
#
#  id          :bigint           not null, primary key
#  name        :string(50)       not null
#  description :text             not null
#  role_type   :integer          default("default_user"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require_relative '../shared_examples/models/crud_operations'

RSpec.describe Role do
  let(:role_types) { { admin: 1, client_admin: 2, default_user: 3 } }

  describe 'database columns' do
    it { is_expected.to have_db_column(:name).of_type(:string).with_options(null: false, limit: 50) }
    it { is_expected.to have_db_column(:description).of_type(:text).with_options(null: false) }
    it { is_expected.to have_db_column(:role_type).of_type(:integer).with_options(default: :default_user, null: false) }
  end

  describe 'attributes' do
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:description) }
    it { is_expected.to respond_to(:role_type) }
  end

  describe 'validations' do
    let!(:valid_role) { build(:role) }
    let(:invalid_attributes) { { name: '', description: '', role_type: nil } }

    context 'when trying to save data' do
      it { is_expected.to validate_presence_of(:name).with_message("can't be blank") }
      it { is_expected.to validate_length_of(:name).is_at_least(1).is_at_most(50) }

      it { is_expected.to validate_presence_of(:description).with_message("can't be blank") }
      it { is_expected.to validate_length_of(:description).is_at_least(1).is_at_most(5000) }

      it { is_expected.to validate_presence_of(:role_type).with_message("can't be blank") }
      it { expect(valid_role).to define_enum_for(:role_type).with_values(role_types) }
    end

    context 'when trying to save invalid data' do
      it 'is invalid with empty name' do
        valid_role.name = ''
        valid_role.save
        expect(valid_role.errors[:name]).to include("can't be blank")
      end

      it 'is invalid with duplicate name' do
        create(:role, name: 'Admin', role_type: 1)
        valid_role.name = 'Admin'
        valid_role.save
        expect(valid_role.errors[:name]).to include('has already been taken')
      end

      it 'is invalid with name length less than 1' do
        valid_role.name = ''
        valid_role.save
        expect(valid_role.errors[:name]).to include('is too short (minimum is 1 character)')
      end

      it 'is invalid with name length greater than 50' do
        valid_role.name = 'A' * 51
        valid_role.save
        expect(valid_role.errors[:name]).to include('is too long (maximum is 50 characters)')
      end

      it 'is invalid with empty description' do
        valid_role.description = ''
        valid_role.save
        expect(valid_role.errors[:description]).to include("can't be blank")
      end

      it 'is invalid with description length less than 1' do
        valid_role.description = ''
        valid_role.save
        expect(valid_role.errors[:description]).to include('is too short (minimum is 1 character)')
      end

      it 'is invalid with description length greater than 500' do
        valid_role.description = 'A' * 5001
        valid_role.save
        expect(valid_role.errors[:description]).to include('is too long (maximum is 5000 characters)')
      end

      it 'is invalid without role_type' do
        valid_role.role_type = nil
        valid_role.save
        expect(valid_role.errors[:role_type]).to include("can't be blank")
      end

      it 'is invalid with role_type not valid' do
        valid_role.role_type = 'fake'
        valid_role.save
        expect(valid_role.errors[:role_type].first).to include('is not included in the list')
      end

      it 'is invalid' do
        valid_role.assign_attributes(invalid_attributes)
        expect(valid_role).not_to be_valid
      end
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:users) }
  end

  describe 'CRUD operations' do
    it_behaves_like 'model crud operations', :role do
      def model = described_class
    end
  end
end
