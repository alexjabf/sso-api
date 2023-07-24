# frozen_string_literal: true

# This is the main API module
module Api
  # This is the main V1 module
  module V1
    # This class manages roles through the API.
    # It provides actions for creating, updating, and deleting clients.
    class ClientsController < ApplicationController
      before_action :authenticate_user!, except: %i[all]
      before_action :set_client, only: %i[show update destroy]

      def all
        data = Client.joins(:configuration).select(
          'clients.id', 'clients.name', 'configurations.provider', 'configurations.provider',
          'configurations.client_key', 'configurations.client_secret', 'configurations.redirect_uri',
          'configurations.domain', 'configurations.audience', 'configurations.default_scope',
          'configurations.custom_fields', 'configurations.client_key_frontend', 'configurations.client_secret_frontend'
        )
        render json: data, status:
      end

      def index
        data = Client.search(params: search_params.to_h).includes(:configuration)
        render json: serializer.new(data, links: paginate(url: api_v1_clients_url, data:))
      end

      def show
        render json: serializer.new(@client)
      end

      def create
        initialize_client
        status = if @configuration.valid? && @client.valid? && @client.save
                   @client.save ? :created : :unprocessable_entity
                 else
                   :unprocessable_entity
                 end
        configuration_errors = @configuration.errors.any? ? @configuration.errors.messages : nil
        render json: serializer.new(@client, links: 'show', params: { configuration_errors: }), status:
      end

      def update
        status = if @client.update(client_params.except(:configuration))
                   @client.configuration.update(client_params[:configuration]) if @client.configuration.present?
                   :ok
                 else
                   :unprocessable_entity
                 end

        render json: serializer.new(@client.reload), status:
      end

      def destroy
        @client.destroy
        render json: { message: 'Client deleted successfully' }
      end

      private

      def serializer = ClientSerializer

      def initialize_client
        @client = Client.new(client_params.except(:configuration))
        @configuration = @client.build_configuration(client_params[:configuration])
      end

      def set_client
        @client = Client.includes(:configuration).find(params[:id])
      end

      def search_params
        params.permit(:name, :description, :client_code, :order, :sort_by, :page, :per_page, :controller, :action)
      end

      def client_params
        params.require(:client).permit(:name, :description, :client_code,
                                       configuration: [:provider, :default_scope, :client_key, :client_secret, :domain,
                                                       :client_key_frontend, :client_secret_frontend, :audience,
                                                       :redirect_uri, { custom_fields: {} }])
      end
    end
  end
end
