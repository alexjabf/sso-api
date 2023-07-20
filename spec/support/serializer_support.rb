# frozen_string_literal: true

# spec/support/serializer_support.rb

# This module serializes the object and returns a hash with the serialized object
# exactly as JSONAPI::Serializer does. This method is used in the specs to
# compare the response body with the serialized object.
module SerializerSupport
  def serialize(object)
    @type = object.class.name.downcase.pluralize
    data = {
      data: {
        id: object.id.to_s,
        type: @type,
        attributes: record_attributes(object)
      }
    }
    object.errors.present? ? record_errors(object, data) : data
    data
  end

  private

  def record_attributes(object)
    attributes = object.attributes.deep_symbolize_keys!.transform_values! { |value| value }
    return attributes unless @type == 'users'

    attributes.except!(:encrypted_password).merge!(role_name: object.role.name)
  end

  def record_errors(record, data)
    data[:data][:attributes].merge!(errors: record.errors.to_hash)
    data
  end
end
