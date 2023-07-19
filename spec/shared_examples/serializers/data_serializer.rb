# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'data serializer' do |class_name|
  include SerializerSupport

  describe 'serialization' do
    let(:hash_object) { serialized_data[:data] }

    it 'includes the correct type' do
      expect(hash_object[:type].to_s).to eq(class_name)
    end

    it 'includes the correct id' do
      expect(hash_object[:id]).to eq(serialize(object)[:data][:id])
    end

    it 'includes the correct attributes' do
      expect(hash_object[:attributes]).to include(serialize(object)[:data][:attributes])
    end

    context 'when there are errors' do
      before do
        object.errors.add(:created_at, 'is invalid')
      end

      it 'includes the errors attribute' do
        expect(serialize(object)[:data][:attributes][:errors]).to eq({ created_at: ['is invalid'] })
      end
    end

    context 'when there are no errors' do
      it 'does not include the errors attribute' do
        expect(hash_object[:attributes]).not_to have_key(:errors)
      end
    end
  end
end
