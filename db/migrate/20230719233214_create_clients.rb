# frozen_string_literal: true

# This is the Client migration that will be used to create clients
class CreateClients < ActiveRecord::Migration[7.0]
  create_table :clients do |t|
    t.string :name, null: false, limit: 50
    t.text :description, null: false, limit: 5000
    t.string :client_code, null: false, index: { unique: true }, limit: 50
    t.jsonb :custom_fields, null: false, default: {}

    t.timestamps
  end
end
