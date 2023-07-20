# frozen_string_literal: true

require_relative '../../../shared_examples/routing/api/v1/crud_operations'

RSpec.describe Api::V1::RolesController do
  it_behaves_like 'routing crud operations', 'users'
end
