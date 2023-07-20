# frozen_string_literal: true

# This module is used to generate pagination links for the response body.
module Authentication
  include ActionController::Cookies
  extend ActiveSupport::Concern

  included do
    def authenticate_user!
      authentication_token = cookies[:Authorization]

      valid_token?(authentication_token) || invalid_authorization
    end

    def sign_in?
      valid_token?(cookies[:Authorization])
      @current_user.present?
    end

    def current_user
      @current_user
    end

    private

    def valid_token?(authentication_token)
      decoded_token = JWT.decode(authentication_token, Rails.application.secrets.secret_key_base).first
      @current_user = User.includes(:tokens).find_by(id: decoded_token['user_id'])
      @current_user.invalid_token?(authentication_token) ? false : @current_user
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      false
    end
  end
end
