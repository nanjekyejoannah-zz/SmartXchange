# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

u1 = User.create!(email: 'example@gmail.com',password: 'password', name: 'User1', language: 'Spanish', language_level: 6)

languages = ["Spanish","English","German"]
language_levels = [1,2,3,4,5,6,7,8,9,10]
ages = [23,25,27,29,31,33,35,37]
titles = ["Baller at Life", "I don't wear the pants", "I want a sushi burrito", "Give that man a horse", "Nothing like a Friday night walk in Retiro", "Shorts o'clock", "Suns out guns out"]

50.times do |n|
  name  = Faker::Name.name
  email = "example#{n+1}@gmail.com"
  password = "password"
  age = ages[rand(ages.count)]
  language = languages[rand(languages.count)]
  language_level = language_levels[rand(language_levels.count)]
  title = titles[rand(titles.count)]
  User.create!(name:  name,
               age: age,
               title: title,
               email: email,
               password: password,
               language: language,
               language_level: language_level
               )
end

# image: File.open("chair_images/Gym-Ergonomic.jpg")
