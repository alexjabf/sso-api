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
class Configuration < ApplicationRecord
  belongs_to :client
  validates :provider, presence: true, inclusion: { in: OAUTH_PROVIDERS }
  validates :default_scope, :redirect_uri, :domain, :audience, :client_key, :client_secret,
            :client_key_frontend, :client_secret_frontend, presence: true
  before_validation :process_custom_fields

  def process_custom_fields
    return if custom_fields.blank?

    client_custom_fields = []
    custom_fields.each do |_index, custom_field|
      client_custom_fields << custom_field if custom_field.present?
    end

    self.custom_fields = client_custom_fields
  end
end
