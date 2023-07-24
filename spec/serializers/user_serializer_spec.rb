# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                 :bigint           not null, primary key
#  client_id          :bigint           default(1), not null
#  role_id            :bigint           default(3), not null
#  first_name         :string(50)       not null
#  last_name          :string(50)       not null
#  custom_fields      :jsonb            not null
#  username           :string(30)       not null
#  email              :string(100)      not null
#  omniauth_provider  :string(120)
#  uid                :string(120)
#  encrypted_password :string(120)      not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
require_relative '../shared_examples/serializers/data_serializer'

RSpec.describe UserSerializer do
  let(:record) { create(:user) }
  let(:serializer) { described_class.new(object) }
  let(:serialized_record) { serializer.serializable_hash.deep_symbolize_keys }

  it_behaves_like 'data serializer', 'users' do
    def object = record
    def serialized_data = serialized_record
  end
end
