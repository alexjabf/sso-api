# frozen_string_literal: true

# == Schema Information
#
# Table name: tokens
#
#  id                   :bigint           not null, primary key
#  authentication_token :string           not null
#  invalidated_at       :datetime         not null
#  user_id              :bigint           not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
require 'rails_helper'

RSpec.describe Token do
  describe 'database columns' do
    it { is_expected.to have_db_column(:authentication_token).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:invalidated_at).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_column(:user_id).of_type(:integer).with_options(null: false) }
  end

  describe 'attributes' do
    it { is_expected.to respond_to(:authentication_token) }
    it { is_expected.to respond_to(:invalidated_at) }
    it { is_expected.to respond_to(:user_id) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'CRUD operations' do
    it_behaves_like 'model crud operations', :token do
      def model = described_class
    end
  end
end
