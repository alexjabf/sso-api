# frozen_string_literal: true

# This controller is used to handle the welcome page
class WelcomeController < ApplicationController
  def index
    response_data = {
      message: 'API Online!',
      timestamp: Time.zone.now
    }

    render json: response_data
  end
end
