# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'json'
require 'open-uri'

# filepath = 'https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list'
# ingredient_serialized = open(filepath).read
# ingredients = JSON.parse(ingredient_serialized)

# puts 'Cleaning Ingredient database...'
# Ingredient.destroy_all

# ingredients['drinks'].each do |ingredient|
#   drinks_ingredient = Ingredient.create!(name: ingredient['strIngredient1'])
#   puts "Created #{drinks_ingredient.name}"
# end

puts 'Cleaning  database...'
Cocktail.destroy_all
Ingredient.destroy_all
Dose.destroy_all

filepath_cocktail = 'https://www.thecocktaildb.com/api/json/v1/1/search.php?f=a'
cocktail_serialized = open(filepath_cocktail).read
cocktails = JSON.parse(cocktail_serialized)

cocktails['drinks'].each do |cocktail|
  puts cocktail['strGlass']
  cocktail_created = Cocktail.create!(name: cocktail['strGlass'], imageURL: cocktail['strDrinkThumb'])

  ingredient_check = cocktail['strIngredient1']
  ingredient = if Ingredient.exists?(ingredient_check)
                 Ingredient.find_by(name: ingredient_check)
               else
                 puts ingredient_check
                 Ingredient.create!(name: ingredient_check)
               end

  dose = Dose.new(description: cocktail['strMeasure1'])
  dose.ingredient = ingredient
  dose.cocktail = cocktail
  dose.save!

  puts "Created #{cocktail_created.name}"
end
