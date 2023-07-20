# frozen_string_literal: true

RSpec.describe Api::V1::RegistrationsController do
  describe 'routing' do
    it 'routes to #login' do
      expect(post: '/api/v1/sign_up').to route_to('api/v1/registrations#sign_up')
    end
  end
end
