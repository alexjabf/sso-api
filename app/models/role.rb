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
class Role < ApplicationRecord
  has_many :users, dependent: :destroy
  validates :name, presence: true, uniqueness: true, length: { in: 1..50 }
  validates :description, presence: true, length: { in: 1..5000 }
  enum role_type: { admin: 1, client_admin: 2, default_user: 3 }
  validates :role_type, presence: true, inclusion: { in: role_types.keys }
end
