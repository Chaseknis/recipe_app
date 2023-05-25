class RecipesController < ApplicationController
  def index
    @recipes = current_user.recipes
  end

  def show
    @recipe = Recipe.find(params[:id])
    @ingredients = @recipe.recipe_foods.where(recipe: @recipe)
  end

  def update
    @recipe = Recipe.find(params[:id])
    @recipe.public = !@recipe.public
    @recipe.save
    redirect_to recipe_path(@recipe), notice: 'Recipe status updated.'
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user = current_user
    puts params.inspect
    if @recipe.save
      flash[:notice] = 'Recipe was successfully created.'
      redirect_to recipes_path
    else
      flash[:alart] = 'Recipe was not created.'
      render :new, status: :unprocessable_entity
    end
  end
 

  # DELETE /recipes/1 or /recipes/1.json
  def destroy
    @recipe = Recipe.find(params[:id])
    @recipe.destroy
    flash[:notice] = 'Recipe deleted!'
    redirect_to recipes_path
  end

  private

  # Only allow a list of trusted parameters through.
  def recipe_params
    params.require(:recipe).permit(:name, :preparation_time, :cooking_time, :description, :public)
  end
end
