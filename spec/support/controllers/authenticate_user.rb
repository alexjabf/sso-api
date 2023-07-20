# frozen_string_literal: true

RSpec.shared_context 'with authenticated user' do
  let(:current_user) { create(:user, role: create(:role, role_type: :admin)) }
  let(:valid_token) { current_user.generate_authentication_token }

  before do
    request&.cookies&.[]=('Authorization', valid_token)
  end
end
