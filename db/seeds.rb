# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

u = User.create!(email: 'example@gmail.com',password: 'password', name: 'Sebastian Peterlin', language: 'Spanish', language_level: 6, title: "Co-founder of smartXchange, IMBA 2016 Candidate at IE Business School", image: File.open("app/assets/images/Sebastian_Peterlin professional.jpg"), age: 27);
u1 = User.create!(email: 'example1@gmail.com',password: 'password', name: 'Patsy Purdy', language: 'Spanish', language_level: 6, title: "English teacher, Masters in Communications graduate", image: File.open("app/assets/images/Patsy Purdy.jpg"), age: 26);
u2 = User.create!(email: 'example2@gmail.com',password: 'password', name: 'Abigale Jacobson', language: 'French', language_level: 7, title: "Dentistry student at Complutense University of Madrid", image: File.open("app/assets/images/Abigale Jacobson.jpg"), age: 24);
u3 = User.create!(email: 'example3@gmail.com',password: 'password', name: 'Coty Smitham', language: 'German', language_level: 5, title: "PhD in Mathematical Science at Complutense University of Madrid", image: File.open("app/assets/images/Coty Smitham.jpg"), age: 28);
u4 = User.create!(email: 'example4@gmail.com',password: 'password', name: 'Janet Collier', language: 'French', language_level: 6, title: "Master in Psychology at Autonomous University of Madrid", image: File.open("app/assets/images/Janet Collier.jpg"), age: 29);
u5 = User.create!(email: 'example5@gmail.com',password: 'password', name: 'Shanie Macejkovic', language: 'English', language_level: 5, title: "Business Development at Bla Bla Car Madrid", image: File.open("app/assets/images/Shanie Macejkovic.jpg"), age: 26);

languages = ["Spanish","English","German","French"]
language_levels = [1,2,3,4,5,6,7,8,9,10]
ages = [23,25,27,29,31,33,35,37]
titles = ["Monetizing intuitive partnerships", "Deploying vertical web services", "Generating frictionless technologies", "Innovating world class niches", "Syndicate b2c niches", "Harnessing front-end metrics", "Generating b2c bandwidth", "Optimizing holistic systems"]





5.times do |n|
  name  = Faker::Name.name
  email = "example#{n+6}@gmail.com"
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
