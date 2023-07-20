# frozen_string_literal: true

# == Schema Information
#
# Table name: tokens
#
#  id                   :bigint           not null, primary key
#  authentication_token :string           not null
#  invalidated_at       :datetime         not null
#  user_id              :bigint           not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
FactoryBot.define do
  factory :token do
    authentication_token { Faker::Internet.device_token }
    invalidated_at { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
    user { FactoryBot.create(:user) }
  end
end
