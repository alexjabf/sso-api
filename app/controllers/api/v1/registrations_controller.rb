# frozen_string_literal: true

# This is the main API module
module Api
  # This is the main V1 module
  module V1
    # This controller is responsible for authenticating the user and generating a JWT token
    class RegistrationsController < ApplicationController
      def sign_up
        user = User.new(registration_params)

        status = user.save ? :ok : :unprocessable_entity
        authentication_token = status == :ok ? user.generate_authentication_token : nil
        data = UserSerializer.new(user, { params: { authentication_token: } })
        render json: data, status:
      end

      private

      def registration_params
        params.require(:registration).permit(:first_name, :last_name, :email, :username,
                                             :password, :password_confirmation, :omniauth_provider, :uid, :role_id)
      end
    end
  end
end
