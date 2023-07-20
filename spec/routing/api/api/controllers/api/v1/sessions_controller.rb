# frozen_string_literal: true

# This is the main API module
module Api
  # This is the main V1 module
  module V1
    # This controller is responsible for authenticating the user and generating a JWT token
    class SessionsController < ApplicationController
      before_action :authenticate_user!, only: :logout

      def login
        user = User.find_by(email: session_params[:email])

        if user&.authenticate(session_params[:password])
          data = ProfileSerializer.new(user, {
                                         params: { authentication_token: user.generate_authentication_token }
                                       })
          render json: data, status: :ok
        else
          render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
      end

      def logout
        @current_user&.invalidate_authentication_token(cookies[:Authorization])
        render json: { message: 'Logged out successfully' }, status: :ok
      end

      private

      def session_params
        params.require(:session).permit(:email, :password)
      end
    end
  end
end
