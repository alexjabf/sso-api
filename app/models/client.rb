# frozen_string_literal: true

# == Schema Information
#
# Table name: clients
#
#  id          :bigint           not null, primary key
#  name        :string(50)       not null
#  description :text             not null
#  client_code :string(50)       not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Client < ApplicationRecord
  has_many :users, dependent: :destroy
  has_one :configuration, dependent: :destroy
  validates :name, presence: true, length: { in: 1..50 }
  validates :description, presence: true, length: { in: 1..5000 }
  validates :client_code, presence: true, uniqueness: true, length: { in: 10..50 }, format: { with: /\A[a-zA-Z0-9]+\Z/ }

  def validate_configuration
    return unless configuration.nil?

    errors.add(:configuration, 'must be present')
  end
end
