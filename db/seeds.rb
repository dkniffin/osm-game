# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Character.create(
  name: "John Smith",
  lat: 35.992591,
  lon: -78.903991,
  current_action: 'move',
  action_details: { target: { lat: 35.0, lon: -78.0 } },)
