require 'rails_helper'
RSpec.describe 'Recipes New Page', type: :feature do
  include Devise::Test::IntegrationHelpers # Include Devise test helpers
  let(:user) { FactoryBot.create(:user, email: 'unique2@example.com', confirmed_at: Time.current) }
  before do
    ActionMailer::Base.deliveries.clear
    user.confirmation_token = Devise.token_generator.generate(User, :confirmation_token)
    user.confirmed_at = Time.current
    user.save
    sign_in user
    visit new_recipe_path
  end
  scenario 'load new recipe page' do
    expect(page).to have_content 'New recipe'
    expect(page).to have_content 'Name'
    expect(page).to have_content 'Description'
    expect(page).to have_content 'Preparation time'
    expect(page).to have_content 'Cooking time'
    expect(page).to have_content 'Public'
  end
  scenario 'allows user to add a recipe' do
    fill_in 'Name', with: 'Jamal Goda'
    fill_in 'Description', with: 'Khao banorer ola'
    fill_in 'Preparation time', with: 1
    fill_in 'Cooking time', with: 1
    check 'Public'
    click_on 'Create Recipe'
    expect(page).to have_content 'Jamal Goda'
  end
end
