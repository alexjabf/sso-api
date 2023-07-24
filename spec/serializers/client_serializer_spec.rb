# frozen_string_literal: true

# == Schema Information
#
# Table name: clients
#
#  id          :bigint           not null, primary key
#  name        :string(50)       not null
#  description :text             not null
#  client_code :string(50)       not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require_relative '../shared_examples/serializers/data_serializer'

RSpec.describe ClientSerializer do
  let(:record) { create(:client) }
  let(:configuration) { create(:configuration, client: record) }
  let(:serializer) { described_class.new(object) }
  let(:serialized_record) { serializer.serializable_hash.deep_symbolize_keys }

  it_behaves_like 'data serializer', 'clients' do
    def object = record
    def serialized_data = serialized_record
  end
end
