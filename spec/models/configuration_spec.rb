# frozen_string_literal: true

# == Schema Information
#
# Table name: configurations
#
#  id                     :bigint           not null, primary key
#  client_id              :bigint           not null
#  provider               :string           default("google_oauth2"), not null
#  default_scope          :string           default("email username profile"), not null
#  redirect_uri           :string           not null
#  domain                 :string           not null
#  audience               :string           not null
#  custom_fields          :jsonb            not null
#  client_key_frontend    :string           not null
#  client_secret_frontend :string           not null
#  client_key             :string           not null
#  client_secret          :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
require 'rails_helper'

RSpec.describe Configuration do
  let(:client) { create(:client) }

  describe 'database columns' do
    it { is_expected.to have_db_column(:client_id).of_type(:integer).with_options(null: false) }
    it { is_expected.to have_db_column(:provider).of_type(:string).with_options(null: false, default: 'google_oauth2') }
    it { is_expected.to have_db_column(:custom_fields).of_type(:jsonb).with_options(null: false, default: {}) }
    it { is_expected.to have_db_column(:redirect_uri).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:domain).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:audience).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:client_key_frontend).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:client_secret_frontend).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:client_key).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:client_secret).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
  end

  describe 'attributes' do
    it { is_expected.to respond_to(:client_id) }
    it { is_expected.to respond_to(:provider) }
    it { is_expected.to respond_to(:default_scope) }
    it { is_expected.to respond_to(:redirect_uri) }
    it { is_expected.to respond_to(:domain) }
    it { is_expected.to respond_to(:custom_fields) }
    it { is_expected.to respond_to(:client_key) }
    it { is_expected.to respond_to(:client_secret) }
    it { is_expected.to respond_to(:client_key_frontend) }
    it { is_expected.to respond_to(:client_secret_frontend) }
  end
end
