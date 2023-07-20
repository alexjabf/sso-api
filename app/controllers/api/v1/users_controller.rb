# frozen_string_literal: true

# This is the main API module
module Api
  # This is the main V1 module
  module V1
    # This class manages users through the API.
    # It provides actions for creating, updating, and deleting users.
    class UsersController < ApplicationController
      before_action :set_user, only: %i[show update destroy]

      def index
        data = User.records(params:)
        render json: serializer.new(data, links: paginate(url: api_v1_users_url, data:))
      end

      def show
        render json: serializer.new(@user, { params: { include_associations: true, params: } })
      end

      def create
        @user = User.new(user_params)
        status = @user.save ? :created : :unprocessable_entity
        render json: serializer.new(@user), status:
      end

      def update
        status = @user.update(user_params) ? :ok : :unprocessable_entity
        render json: serializer.new(@user.reload), status:
      end

      def destroy
        @user.destroy
        render json: { message: 'User deleted successfully' }
      end

      private

      def serializer = UserSerializer

      def set_user
        relation = action_name == 'show' ? User.preload(:role) : User
        @user = relation.find(params[:id])
      end

      def user_params
        params.require(:user).permit(:first_name, :last_name, :email, :username, :password, :password_confirmation,
                                     :omniauth_provider, :uid, :role_id)
      end
    end
  end
end
