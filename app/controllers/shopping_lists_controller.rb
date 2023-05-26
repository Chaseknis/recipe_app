class ShoppingListsController < ApplicationController
  def index
    @user = current_user
    @recipes = Recipe.includes(recipe_foods: :food).where(user: @user)

    @ingredients = RecipeFood.includes(food: :recipe_foods)
      .where(recipe: @recipes)
      .group_by { |ingredient| ingredient.food.name }

    @total_price = @ingredients.sum do |_food, ingredients|
      ingredients.sum { |ingredient| ingredient.food.price * ingredient.quantity }
    end
  end
end
