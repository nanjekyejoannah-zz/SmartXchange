# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

u1 = User.create!(email: 'example1@gmail.com',password: 'password')
u2 = User.create!(email: 'example2@gmail.com', password: 'password')

# image: File.open("chair_images/Gym-Ergonomic.jpg")
