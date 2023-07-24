# frozen_string_literal: true

# This is the Configurations migration that will be used to create omniauth configurations for clients
class CreateConfigurations < ActiveRecord::Migration[7.0]
  def change
    create_table :configurations do |t|
      t.references :client, null: false, foreign_key: true
      t.string :provider, null: false, default: 'google_oauth2'
      t.string :default_scope, null: false, default: 'email username profile'
      t.jsonb :custom_fields, null: false, default: {}
      required_columns(t)

      t.timestamps
    end
  end

  def required_columns(table)
    table.string :redirect_uri, null: false
    table.string :domain, null: false
    table.string :audience, null: false
    table.string :client_key_frontend, null: false
    table.string :client_secret_frontend, null: false
    table.string :client_key, null: false
    table.string :client_secret, null: false
  end
end
