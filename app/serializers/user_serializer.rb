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

# This is the serializer for the User model.
# It uses the JSONAPI::Serializer gem.
# It provides caching for the serializer.
class UserSerializer
  include JSONAPI::Serializer

  set_type 'users'
  attributes :id, :first_name, :last_name, :email, :username, :custom_fields,
             :omniauth_provider, :uid, :role_id, :client_id, :created_at, :updated_at

  attribute :role_name do |object|
    object&.role&.name
  end

  attribute :client_name do |object|
    object&.client&.name
  end

  def errors
    object.errors.messages
  end

  meta do |_object, params|
    { authentication_token: params[:authentication_token] }
  end

  attributes :errors, if: proc { |record| record.errors.present? }

  cache_options store: Rails.cache, namespace: 'jsonapi-serializer', expires_in: 24.hours
end
