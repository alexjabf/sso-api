# frozen_string_literal: true

# This is the main API module
module Api
  # This is the main V1 module
  module V1
    # This is the OmniauthCallbacksController class that handles the callbacks from the social networks providers.
    class OmniauthCallbacksController < ApplicationController
      include ActiveStorage::SetCurrent

      def auth
        client = Client.includes(:configuration).find_by(id: allowed_params[:client_id])
        if client.present?
          user_data = build_user_data(client.configuration)
          user, status = User.from_omniauth(user_data, user_data['sub'])
          authentication_token = status == :ok ? user.generate_authentication_token : nil
          render json: UserSerializer.new(user, { params: { authentication_token: } }), status:
        else
          render json: { message: 'Company not found' }, status: :unprocessable_entity
        end
      end

      private

      def build_user_data(configuration)
        user_data = auth0_client(configuration)
        return user_data if allowed_params[:custom_fields].blank?

        user_data.merge!(custom_fields: allowed_params[:custom_fields])
      end

      def auth0_client(configuration)
        @auth0_client ||= Auth0Client.new(
          client_id: configuration.client_key,
          client_secret: configuration.client_secret,
          domain: configuration.domain.sub(%r{\A(?:https?://)?(.*?)/?\z}, '\1')
        )
        @auth0_client.userinfo(allowed_params[:access_token]).deep_symbolize_keys!
      end

      def allowed_params
        params.permit(
          :client_id, :access_token, :token_type, :provider, :uid, :code, :redirect_uri, :state,
          :scope, :access_token, :omniauth_callback, omniauth_callback: {}, custom_fields: {}
        )
      end
    end
  end
end
