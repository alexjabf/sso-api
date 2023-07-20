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

# This is the serializer for the Client model.
# It uses the JSONAPI::Serializer gem.
# It provides caching for the serializer.
class ClientSerializer
  include JSONAPI::Serializer

  set_type 'clients'
  attributes :id, :name, :description, :custom_fields, :client_code, :created_at, :updated_at

  def errors
    object.errors.messages
  end

  attributes :errors, if: proc { |record| record.errors.present? }

  cache_options store: Rails.cache, namespace: 'jsonapi-serializer', expires_in: 24.hours
end
