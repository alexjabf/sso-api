# frozen_string_literal: true

# This is the User migration that will be used to create clients
class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.references :role, null: false, default: 3, foreign_key: true
      t.string :first_name, limit: 50, null: false
      t.string :last_name, limit: 50, null: false
      t.string :username, limit: 30, null: false, index: { unique: true }
      t.string :email, limit: 100, null: false, index: { unique: true }
      authentication_fields(t)

      t.timestamps
    end
  end

  def authentication_fields(table)
    table.string :omniauth_provider, limit: 120
    table.string :uid, limit: 120
    table.string :encrypted_password, null: false, limit: 120
  end
end
