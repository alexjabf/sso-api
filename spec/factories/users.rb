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
#  omniauth_provider  :string(120)
#  uid                :string(120)
#  encrypted_password :string(120)      not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
FactoryBot.define do
  password = Faker::Internet.password(min_length: 8, max_length: 20)
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    username { "username#{Faker::Number.within(range: 1..999_999)}" }
    password { password }
    password_confirmation { password }
    encrypted_password { RbNaCl::PasswordHash.argon2_str(password) }
    role { FactoryBot.create(:role) }
  end
end
