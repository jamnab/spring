# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Demo Company Inc.

User.create(username: "pindoit", email: "info@pindoit.com",
            password: "pindoit", password_confirmation: "pindoit",
            admin: true, first_name: "Pindoit", last_name: "Admin")

# demo organization
Organization.create(name: "Demo Company Inc.", activated: true)

# demo manager
User.create(username: "demoman", email: "man@demo.com",
            password: "demoman", password_confirmation: "demoman",
            first_name: "Manager", last_name: "Demoson",
            job_title: "Manager", organization_id: 1, manager: true)

# demo personnel
40.times do |i|
  name = i.to_words.delete(' ')
  User.create(username: name, email: "#{name}@demo.com",
              password: name, password_confirmation: name,
              first_name: name.capitalize,
              last_name: "Demoson",
              job_title: "Employee", organization_id: 1)
end

# demo posts
3.times do |type|
  post_type = "Work" if type == Post::WORK
  post_type = "Play" if type == Post::PLAY
  post_type = "Facility" if type == Post::FACILITY

  # archived
  Post.create(title: "Archived #{post_type} Post",
              content: Forgery(:lorem_ipsum).words(34).capitalize,
              threshold: 20,
              graveyard: true,
              user_id: 2 + rand(30),
              organization_id: 1,
              post_type: type)

  # downvoted
  terrible = Post.create(title: "Terrible #{post_type} Post",
              content: Forgery(:lorem_ipsum).words(34).capitalize,
              threshold: 20,
              user_id: 2 + rand(30),
              organization_id: 1,
              post_type: type)
  15.times do |uid|
    Opinion.create(opinionable_id: terrible.id, opinionable_type: "Post",
                   positive: false, user_id: 10 + uid)
  end
  terrible.update(opinion: -15)

  # upvoted, two plain comments, 1 suggestion
  trending = Post.create(title: "Trending #{post_type} Post",
              content: Forgery(:lorem_ipsum).words(34).capitalize,
              threshold: 20,
              user_id: 2 + rand(30),
              organization_id: 1,
              post_type: type)
  15.times do |uid|
    Opinion.create(opinionable_id: trending.id, opinionable_type: "Post",
                   positive: true, user_id: 10 + uid)
  end
  trending.update(opinion: 15)
  2.times do |c|
    Comment.create(commentable_id: trending.id, commentable_type: "Post", user_id: 2 + rand(30),
                   content: "Plain old comment, nothing special.", suggestion: false)
  end
  Comment.create(commentable_id: trending.id, commentable_type: "Post", user_id: 2 + rand(30),
                 content: "Alternative solution here!", suggestion: true)

  # doit (post), one plain comment
  doit = Post.create(title: "Doit #{post_type} Post",
              content: Forgery(:lorem_ipsum).words(34).capitalize,
              threshold: 20,
              user_id: 2 + rand(30),
              organization_id: 1,
              post_type: type)
  30.times do |uid|
    Opinion.create(opinionable_id: doit.id, opinionable_type: "Post",
                   positive: true, user_id: 10 + uid)
  end
  doit.update(opinion: 30)
  Comment.create(commentable_id: doit.id, commentable_type: "Post", user_id: 2 + rand(30),
                 content: "Great idea!", suggestion: false)

  # doit (alt), three plain comment, two suggestions (one doit)
  alt_doit = Post.create(title: "Alt Doit #{post_type} Post",
              content: Forgery(:lorem_ipsum).words(34).capitalize,
              threshold: 20,
              user_id: 2 + rand(30),
              organization_id: 1,
              post_type: type)
  10.times do |uid|
    Opinion.create(opinionable_id: alt_doit.id, opinionable_type: "Post",
                   positive: true, user_id: 10 + uid)
  end
  alt_doit.update(opinion: 10)
  3.times do |c|
    Comment.create(commentable_id: alt_doit.id, commentable_type: "Post", user_id: 2 + rand(30),
                   content: "Plain old comment, nothing special.", suggestion: false)
  end
  doit_com = Comment.create(commentable_id: alt_doit.id, commentable_type: "Post", user_id: 2 + rand(30),
                            content: "Alternative solution 1!", suggestion: true)
  Comment.create(commentable_id: alt_doit.id, commentable_type: "Post", user_id: 2 + rand(30),
                 content: "Alternative solution 2!", suggestion: true)
  35.times do |uid|
    Opinion.create(opinionable_id: doit_com.id, opinionable_type: "Comment",
                   positive: true, user_id: 10 + uid)
  end
  doit_com.update(opinion: 35)
end

# sample posts
# 3.times do |i|
#   post_type = "Work" if i == Post::WORK
#   post_type = "Play" if i == Post::PLAY
#   post_type = "Facility" if i == Post::FACILITY

#   Post.create(title: "Regular #{post_type} Post",
#               content: Forgery(:lorem_ipsum).words(34).capitalize,
#               threshold: 20,
#               user_id: 1,
#               organization_id: 1,
#               post_type: i)

#   Post.create(title: "Graveyard #{post_type} Post",
#               content: Forgery(:lorem_ipsum).words(34).capitalize,
#               threshold: 20,
#               user_id: 1,
#               organization_id: 1,
#               post_type: i,
#               graveyard: true)

#   Post.create(title: "Doit #{post_type} Post",
#               content: Forgery(:lorem_ipsum).words(34).capitalize,
#               threshold: 20,
