# frozen_string_literal: true

# Application controller class for the API
class ApplicationController < ActionController::API
  include Pagination
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActionDispatch::Http::Parameters::ParseError, with: :handle_bad_request

  private

  def record_not_found
    message = 'Record not found.'
    error = 'RecordNotFound'
    render json: { data: { message:, error: } }, status: :not_found
  end

  def handle_bad_request
    message = 'Invalid request parameters. Please check your request.'
    error = 'ParseError'
    render json: { data: { message:, error: } }, status: :bad_request
  end
end
