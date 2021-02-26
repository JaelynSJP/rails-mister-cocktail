# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'json'
require 'open-uri'

puts 'Cleaning  Cocktail database...'
Cocktail.destroy_all
puts 'Cleaning  Ingredient database...'
Ingredient.destroy_all
puts 'Cleaning  Dose database...'
Dose.destroy_all

filepath_cocktail = 'https://www.thecocktaildb.com/api/json/v1/1/search.php?s=margarita'
cocktail_serialized = open(filepath_cocktail).read
cocktails = JSON.parse(cocktail_serialized)

cocktails['drinks'].each do |cocktail|
  cocktail_created = Cocktail.create!(name: cocktail['strDrink'], imageURL: cocktail['strImageSource'])
  ingredient_check = cocktail['strIngredient1']
  # if Ingredient.exists?(name: ingredient_check)
  #   puts "#{ingredient_check} exist"
  # else 
  #   puts "#{ingredient_check} not exist"
  #   Ingredient.create!(name: ingredient_check)
  # end
  ingredient = if Ingredient.exists?(name: ingredient_check)
                 Ingredient.find_by(name: ingredient_check)
               else
                 Ingredient.create!(name: ingredient_check)
               end

  dose = Dose.new(description: cocktail['strMeasure1'])
  dose.ingredient = ingredient
  dose.cocktail = cocktail_created
  dose.save!

  puts "Created #{cocktail_created.name}"
end
