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
class Token < ApplicationRecord
  belongs_to :user

  validates :authentication_token, presence: true
  validates :invalidated_at, presence: true
end
