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
FactoryBot.define do
  factory :role do
    name { Faker::Lorem.words.join(' ').titlecase }
    description { Faker::Lorem.paragraph }
    role_type { %i[admin client_admin default_user].sample }
  end
end
