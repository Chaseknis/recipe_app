require 'rails_helper'
RSpec.describe 'Recipes Index Page', type: :feature do
  include Devise::Test::IntegrationHelpers # Include Devise test helpers
  let(:user) { FactoryBot.create(:user, email: 'unique1@example.com', confirmed_at: Time.current) }
  context 'when there are no recipes' do
    before do
      ActionMailer::Base.deliveries.clear
      user.confirmation_token = Devise.token_generator.generate(User, :confirmation_token)
      user.confirmed_at = Time.current
      user.save
      sign_in user
      visit recipes_path
    end

    it 'displays a message saying there are no recipes available' do
      expect(page).to have_content 'No recipe available'
    end
    scenario 'displays a list of recipes' do
      expect(page).to have_content 'Recipes'
      expect(page).to have_link 'Add New Recipe'
    end
  end
  context 'when there are recipes available' do
    before do
      ActionMailer::Base.deliveries.clear
      user.confirmation_token = Devise.token_generator.generate(User, :confirmation_token)
      user.confirmed_at = Time.current
      user.save
      sign_in user
      @recipes = FactoryBot.create_list(:recipe, 3, user:)
      visit recipes_path
    end
    scenario 'displays a list of recipes' do
      visit recipes_path
      expect(page).to have_selector '.recipe-container', count: 3
    end
    it 'displays a list of recipes' do
      @recipes.each do |recipe|
        expect(page).to have_link(recipe.name, href: recipe_path(recipe))
        expect(page).to have_content(recipe.description)
      end
    end
    scenario 'allows user to delete a recipe' do
      click_on 'Remove', match: :first
      expect(page).to have_selector '.recipe-container', count: 2
    end
    scenario 'user can add a new recipe' do
      click_on 'Add New Recipe'
      expect(page).to have_current_path(new_recipe_path)
    end
    scenario 'allows user to add a recipe' do
      click_on 'Add New Recipe'
      fill_in 'Name', with: 'Jamal Goda'
      fill_in 'Description', with: 'Khao banorer ola'
      fill_in 'Preparation time', with: 1
      fill_in 'Cooking time', with: 1
      check 'Public'
      click_on 'Create Recipe'
      expect(page).to have_content 'Jamal Goda'
      expect(page).to have_selector '.recipe-container', count: 4
    end
  end
end
