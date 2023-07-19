# frozen_string_literal: true

# This is the Role migration that will be used to create roles for users
class CreateRoles < ActiveRecord::Migration[7.0]
  def change
    create_table :roles do |t|
      t.string :name, null: false, index: { unique: true }, limit: 50
      t.text :description, null: false, limit: 5000
      t.integer :role_type, default: 3, null: false

      t.timestamps
    end
  end
end
