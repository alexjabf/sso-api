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

# This is the serializer for the Role model.
# It uses the JSONAPI::Serializer gem.
# It provides caching for the serializer.
class RoleSerializer
  include JSONAPI::Serializer

  set_type 'roles'
  attributes :id, :name, :description, :role_type, :created_at, :updated_at

  def errors
    object.errors.messages
  end

  attributes :errors, if: proc { |record| record.errors.present? }

  cache_options store: Rails.cache, namespace: 'jsonapi-serializer', expires_in: 24.hours
end
