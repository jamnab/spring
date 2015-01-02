# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(username: "pindoit", email: "info@pindoit.com", password: "pindoit", password_confirmation: "pindoit", admin: true, first_name: "Pindoit", last_name: "Admin")

# sample organization
Organization.create(name: "Sample Org", activated: true)

# sample posts
3.times do |i|
  post_type = "Work" if i == Post::WORK
  post_type = "Play" if i == Post::PLAY
  post_type = "Facility" if i == Post::FACILITY

  Post.create(title: "Regular #{post_type} Post",
              content: Forgery(:lorem_ipsum).words(34).capitalize,
              threshold: 50,
              user_id: 1,
              organization_id: 1,
              post_type: i)

  Post.create(title: "Graveyard #{post_type} Post",
              content: Forgery(:lorem_ipsum).words(34).capitalize,
              threshold: 50,
              user_id: 1,
              organization_id: 1,
              post_type: i,
              graveyard: true)

  Post.create(title: "Doit #{post_type} Post",
              content: Forgery(:lorem_ipsum).words(34).capitalize,
              threshold: 50,
              user_id: 1,
              organization_id: 1,
              post_type: i,
              traction: 80)
end
