require 'rails_helper'
RSpec.describe Recipe, type: :model do
  before(:example) do
    @user1 = User.create(name: 'Alpha', email: 'alpha@gmail.com', password: 'password', confirmed_at: Time.now)
    @recipe1 = Recipe.create(name: 'Recipe2', description: 'Description2', cooking_time: 1,
                             preparation_time: 1, user_id: @user1.id)
    @food1 = Food.create(name: 'apple1', measurement_unit: 'kg', price: 1.5, quantity: 45, user_id: @user1.id)
    @recipe_food11 = RecipeFood.create(recipe: @recipe1, food: @food1, quantity: 1)
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(@recipe1).to be_valid
    end
    it 'is not valid without name' do
      @recipe1.name = ''
      expect(@recipe1).to_not be_valid
    end
  end

  describe 'methods' do
    describe '#total_food_items' do
      it 'returns the total number of unique food items in the recipe' do
        expect(@recipe1.total_food_items).to eq(1)
      end
    end
    describe '#total_price' do
      it 'calculates the total price of the recipe' do
        expect(@recipe1.total_price).to_not eq(82.5)
      end
    end
  end
end
