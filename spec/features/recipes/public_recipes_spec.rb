require 'rails_helper'

RSpec.feature 'Foods index', type: :feature do
  include Devise::Test::IntegrationHelpers # Include Devise test helpers
  let(:user) { FactoryBot.create(:user, confirmed_at: Time.current) }
  before do
    ActionMailer::Base.deliveries.clear
    user.confirmation_token = Devise.token_generator.generate(User, :confirmation_token)
    user.confirmed_at = Time.current
    user.save
    sign_in user
    FactoryBot.create_list(:food, 3, user:)
    # visit new_food_path
  end
end
