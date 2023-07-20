# frozen_string_literal: true

# This is the main API module
module Api
  # This is the main V1 module
  module V1
    # This class manages roles through the API.
    # It provides actions for creating, updating, and deleting clients.
    class ClientsController < ApplicationController
      before_action :set_client, only: %i[show update destroy]

      def index
        data = Client.records(params:)
        render json: serializer.new(data, links: paginate(url: api_v1_clients_url, data:))
      end

      def show
        render json: serializer.new(@client)
      end

      def create
        @client = Client.new(client_params)
        status = @client.save ? :created : :unprocessable_entity
        render json: serializer.new(@client, links: 'show'), status:
      end

      def update
        status = @client.update(client_params) ? :ok : :unprocessable_entity
        render json: serializer.new(@client.reload), status:
      end

      def destroy
        @client.destroy
        render json: { message: 'Client deleted successfully' }
      end

      private

      def serializer = ClientSerializer

      def set_client
        @client = Client.find(params[:id])
      end

      def client_params
        params.require(:client).permit(:name, :description, :client_code, custom_fields: %i[name type])
      end
    end
  end
end
