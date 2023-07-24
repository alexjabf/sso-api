# frozen_string_literal: true

# This is the OmniauthUser class to be included in the user model to handle the
# omniauth user's registrations
module OmniauthUser
  extend ActiveSupport::Concern

  class_methods do
    attr_accessor :provider, :resource_params

    def from_omniauth(resource_params, provider)
      @provider = provider
      @resource_params = resource_params
      @email = email_address
      return [nil, :unprocessable_entity] if @email.nil?

      user = User.find_by(email: @email)
      return create_omniauth_user if user.nil?

      [user, :ok]
    end

    def email_address
      resource_params[:email] || resource_params[:mail] ||
        resource_params[:emailAddress] || resource_params[:userPrincipalName]
    end
  end

  class_methods do
    def create_omniauth_user
      @resource = User.new(email: @email, omniauth_provider: provider)
      @resource.uid = omniauth_provider_id
      user_credentials && user_information
      status = @resource.save ? :ok : :unprocessable_entity

      [@resource, status]
    end

    def user_credentials
      @resource.username = random_username
      @resource.password = random_password
      @resource.password_confirmation = @resource.password
    end

    def user_information
      @resource.first_name = assign_first_name
      @resource.last_name = assign_last_name
      @resource.custom_fields = @resource_params[:custom_fields] if @resource_params[:custom_fields].present?
    end
  end

  class_methods do
    def omniauth_provider_id = resource_params[:id] || resource_params[:sub]

    def random_username
      username = social_network_username
      return username if username.present?

      loop do
        username = [('a'..'z').to_a.sample(4) + (0..9).to_a.sample(5)].join
        username_taken = User.exists?(username:)

        return username unless username_taken
      end
    end

    def social_network_username
      username = username_param&.downcase
      username.present? && !User.exists?(username:) ? username : nil
    end

    def username_param
      resource_params[:username] || resource_params[:login] || resource_params[:twitter_username] ||
        resource_params[:nickname] || @email.split('@').first
    end

    def random_password
      [('A'..'Z').to_a.sample(4) + ('a'..'z').to_a.sample(4) + (0..9).to_a.sample(5) + %w[! $ #].sample(1)].join
    end
  end

  class_methods do
    def assign_first_name
      resource_params[:first_name] || resource_params[:given_name] ||
        resource_params[:givenName] || resource_params[:localizedFirstName] || @email.split('@').first || ''
    end

    def assign_last_name
      resource_params[:last_name] || resource_params[:family_name] || resource_params[:surname] ||
        resource_params[:localizedLastName] || @email.split('@').first || ''
    end
  end
end
