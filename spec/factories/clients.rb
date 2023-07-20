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
FactoryBot.define do
  factory :client do
    name { Faker::Company.name }
    description { Faker::Lorem.paragraph }
    client_code { Faker::Alphanumeric.alphanumeric(number: 10) }
    custom_fields { CUSTOM_FIELDS.shuffle.take(rand(1..CUSTOM_FIELDS.length)) }
  end
end
