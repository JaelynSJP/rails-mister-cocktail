# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'json'
require 'open-uri'

filepath = 'https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list'
ingredient_serialized = open(filepath).read
ingredients = JSON.parse(ingredient_serialized)

puts "Cleaning database..."
Ingredient.destroy_all

ingredients['drinks'].each do |ingredient|
  drinks_ingredient = Ingredient.create!(name: ingredient['strIngredient1'])
  puts "Created #{drinks_ingredient.name}"
end
