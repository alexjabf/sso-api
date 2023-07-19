# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'routing crud operations' do |controller_name|
  describe 'routing' do
    it 'routes to #index' do
      expect(get: "/api/v1/#{controller_name}").to route_to("api/v1/#{controller_name}#index")
    end

    it 'routes to #show' do
      expect(get: "/api/v1/#{controller_name}/1").to route_to("api/v1/#{controller_name}#show", id: '1')
    end

    it 'routes to #create' do
      expect(post: "/api/v1/#{controller_name}").to route_to("api/v1/#{controller_name}#create")
    end

    it 'routes to #update via PUT' do
      expect(put: "/api/v1/#{controller_name}/1").to route_to("api/v1/#{controller_name}#update", id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: "/api/v1/#{controller_name}/1").to route_to("api/v1/#{controller_name}#update", id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: "/api/v1/#{controller_name}/1").to route_to("api/v1/#{controller_name}#destroy", id: '1')
    end
  end
end
