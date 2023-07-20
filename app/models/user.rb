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

# User Model - This file contains the model definition for the user model.
class User < ApplicationRecord
  attr_accessor :password, :password_confirmation

  belongs_to :role
  validates :role_id, numericality: { only_integer: true }, length: { minimum: 1, maximum: 3 }
  validates :first_name, :last_name, presence: true, length: { in: 1..50 }
  validates :email, presence: true, uniqueness: true, email: { mode: :strict, require_fqdn: true },
                    length: { in: 5..100 }
  validates :username, presence: true, length: { minimum: 8, maximum: 30 },
                       uniqueness: true, format: { with: /\A[a-zA-Z0-9]+\Z/ }
  validates :omniauth_provider, length: { maximum: 120 }, allow_blank: true
  validates :uid, length: { maximum: 120 }, allow_blank: true
  validates :password, :password_confirmation, presence: true, on: :create
  validates :password, length: { minimum: 8, maximum: 20 }, if: -> { password.present? }
  validates :password_confirmation, length: { minimum: 8, maximum: 20 }, if: -> { password_confirmation.present? }
  validate :passwords_match
  after_validation :encrypt_password

  private

  def encrypt_password
    return if password.blank? || !password.is_a?(String)

    self.encrypted_password = RbNaCl::PasswordHash.argon2_str(password)
  end

  def passwords_match
    errors.add(:password, "doesn't match confirmation") if password != password_confirmation
  end
end
