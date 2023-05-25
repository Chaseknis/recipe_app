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
    visit foods_path
  end
  scenario 'displays a list of foods' do
    expect(page).to have_link 'Add food'
    expect(page).to have_selector 'table tbody tr', count: 3
  end
  scenario 'allows user to delete a food' do
    click_on 'Delete', match: :first
    expect(page).to have_selector 'table tbody tr', count: 2
  end
  scenario 'user can add a new food' do
    click_on 'Add food'
    expect(page).to have_current_path(new_food_path)
  end
  scenario 'allows user to add a food' do
    click_on 'Add food'
    fill_in 'food_name', with: 'Jamal Goda'
    fill_in 'food_measurement_unit', with: 'Pound'
    fill_in 'food_price', with: 10.00
    fill_in 'food_quantity', with: 10
  end
end