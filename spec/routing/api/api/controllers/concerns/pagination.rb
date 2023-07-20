# frozen_string_literal: true

# This module is used to generate pagination links for the response body.
module Pagination
  include Rails.application.routes.url_helpers
  extend ActiveSupport::Concern

  included do
    def paginate(url: nil, data: [])
      return {} if url.nil? || data.empty?

      navigation_links(url, data).merge!(pagination_information(data))
    end
  end

  private

  def navigation_links(url, data)
    {
      first: controller_url(url:, page: 1, per_page: params[:per_page]),
      last: controller_url(url:, page: data.total_pages, per_page: params[:per_page])
    }.merge!(main_navigation_links(url, data))
  end

  def main_navigation_links(url, data)
    {
      previous: controller_url(url:, page: data.previous_page, per_page: params[:per_page]),
      current: controller_url(url:, page: data.current_page, per_page: params[:per_page]),
      next: controller_url(url:, page: data.next_page, per_page: params[:per_page])
    }
  end

  def pagination_information(data)
    {
      first_page: 1, previous_page: data.previous_page, current_page: data.current_page,
      next_page: data.next_page, last_page: data.total_pages, total_pages: data.total_pages
    }
  end

  def controller_url(url:, page: 1, per_page: 20)
    "#{url}?page=#{page}&per_page=#{per_page}"
  end
end
