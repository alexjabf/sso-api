# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Pagination do
  controller(ApplicationController) do
    def index
      roles = Role.paginate(page: params[:page], per_page: params[:per_page])
      render json: paginate(url: 'http://test.host/api/v1/roles', data: roles)
    end
  end

  describe '#pagination_links' do
    context 'when there is data' do
      let(:roles) { create_list(:role, 10) }
      let(:url) { api_v1_roles_url }

      before do
        roles
        get :index, params: { per_page: 2, page: 3 }
      end

      it 'returns a hash with pagination links and information' do
        response_body = response.parsed_body

        links = navigation_links.merge!(pagination_information)
        expect(response_body.deep_symbolize_keys!).to include(links)
      end
    end

    context 'when there is no data' do
      before { get :index, params: { per_page: 2, page: 3 } }

      it 'returns an empty hash' do
        response_body = response.parsed_body
        expect(response_body).to eq({})
      end
    end
  end

  def navigation_links
    {
      first: "#{url}?page=1&per_page=2",
      previous: "#{url}?page=2&per_page=2",
      current: "#{url}?page=3&per_page=2",
      next: "#{url}?page=4&per_page=2",
      last: "#{url}?page=5&per_page=2"
    }
  end

  def pagination_information
    {
      first_page: 1,
      previous_page: 2,
      current_page: 3,
      next_page: 4,
      last_page: 5,
      total_pages: 5
    }
  end
end
