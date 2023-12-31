# frozen_string_literal: true

# This is the Tokens migration that will be used to create expired tokens for users
class CreateTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :tokens do |t|
      t.string :authentication_token, null: false
      t.datetime :invalidated_at, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
