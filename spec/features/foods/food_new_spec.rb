require 'rails_helper'

RSpec.feature 'Foods index', type: :feature do
  include Devise::Test::IntegrationHelpers # Include Devise test helpers
  let(:user) { FactoryBot.create(:user, email: 'unique13@example.com', confirmed_at: Time.current) }
  before do
    ActionMailer::Base.deliveries.clear
    user.confirmation_token = Devise.token_generator.generate(User, :confirmation_token)
    user.confirmed_at = Time.current
    user.save
    sign_in user
    FactoryBot.create_list(:food, 3, user:)
    visit new_food_path
  end
  scenario 'loads add new food page' do
    expect(page).to have_content 'Add New Food'
    expect(page).to have_link 'Back to foods'
    expect(page).to have_button 'Add Food'
  end
  scenario 'Expect user to go back' do
    click_on 'Back to foods'
    expect(page).to have_current_path(foods_path)
  end

  scenario 'allows user to add a food' do
    fill_in 'food_name', with: 'Jamal Goda'
    fill_in 'food_measurement_unit', with: 'Pound'
    fill_in 'food_price', with: 10.00
    fill_in 'food_quantity', with: 10
    click_on 'Add Food'
    expect(page).to have_current_path(foods_path)
  end
end
