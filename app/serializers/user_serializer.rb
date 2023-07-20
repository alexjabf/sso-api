# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                 :bigint           not null, primary key
#  role_id            :bigint           default(3), not null
#  first_name         :string(50)       not null
#  last_name          :string(50)       not null
#  username           :string(30)       not null
#  email              :string(100)      not null
#  omniauth_provider  :string(20)
#  uid                :string(100)
#  encrypted_password :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

# This is the serializer for the User model.
# It uses the JSONAPI::Serializer gem.
# It provides caching for the serializer.
class UserSerializer
  include JSONAPI::Serializer

  set_type 'users'
  attributes :id, :first_name, :last_name, :email, :username,
             :omniauth_provider, :uid, :role_id, :created_at, :updated_at

  attribute :role_name do |object|
    object&.role&.name
  end

  def errors
    object.errors.messages
  end

  attributes :errors, if: proc { |record| record.errors.present? }

  cache_options store: Rails.cache, namespace: 'jsonapi-serializer', expires_in: 24.hours
end
