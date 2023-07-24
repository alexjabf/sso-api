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
FactoryBot.define do
  factory :configuration do
    client { FactoryBot.create(:client) }
    provider { OAUTH_PROVIDERS.sample }
    default_scope { 'email username profile' }
    client_key_frontend { Faker::Alphanumeric.alphanumeric(number: 100) }
    client_secret_frontend { Faker::Alphanumeric.alphanumeric(number: 100) }
    client_key { Faker::Alphanumeric.alphanumeric(number: 100) }
    client_secret { Faker::Alphanumeric.alphanumeric(number: 100) }
    redirect_uri { Faker::Internet.url }
    domain { Faker::Internet.domain_name }
    audience { Faker::Internet.domain_name }
    custom_fields { CUSTOM_FIELDS.shuffle.take(rand(1..CUSTOM_FIELDS.length)) }
  end
end
