# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Welcome routing' do
  it 'routes to welcome#index' do
    expect(get: '/').to route_to('welcome#index')
  end
end
