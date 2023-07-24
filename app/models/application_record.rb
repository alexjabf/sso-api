# frozen_string_literal: true

# This is the base class for all models in the application.
class ApplicationRecord < ActiveRecord::Base
  include Scopes
  include OmniauthUser

  primary_abstract_class
end
