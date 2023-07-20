# frozen_string_literal: true

# This is the main API module
module Api
  # This is the main V1 module
  module V1
    # This class manages roles through the API.
    # It provides actions for creating, updating, and deleting roles.
    class RolesController < ApplicationController
      before_action :set_role, only: %i[show update destroy]

      def index
        data = Role.records(params:)
        render json: serializer.new(data, links: paginate(url: api_v1_roles_url, data:))
      end

      def show
        render json: serializer.new(@role, { params: { include_associations: true } })
      end

      def create
        @role = Role.new(role_params)
        status = @role.save ? :created : :unprocessable_entity
        render json: serializer.new(@role), status:
      end

      def update
        status = @role.update(role_params) ? :ok : :unprocessable_entity
        render json: serializer.new(@role.reload), status:
      end

      def destroy
        @role.destroy
        render json: { message: 'Role deleted successfully' }
      end

      private

      def serializer = RoleSerializer

      def set_role
        @role = Role.find(params[:id])
      end

      def role_params
        params.require(:role).permit(:name, :description, :role_type)
      end
    end
  end
end
