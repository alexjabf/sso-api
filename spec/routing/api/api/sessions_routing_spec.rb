# frozen_string_literal: true

RSpec.describe Api::V1::SessionsController do
  describe 'routing' do
    it 'routes to #login' do
      expect(post: '/api/v1/login').to route_to('api/v1/sessions#login')
    end

    it 'routes to #logout' do
      expect(delete: '/api/v1/logout').to route_to('api/v1/sessions#logout')
    end
  end
end
