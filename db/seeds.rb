# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#

# Department.create(name: 'Events')
# Department.create(name: 'Marketing')
# Department.create(name: 'Human Resources')
# Department.create(name: 'Finance')
# Department.create(name: 'Purchasing')
# Department.create(name: 'Sales')
# Department.create(name: 'IT')
# Department.create(name: 'Inventory')
# Department.create(name: 'Quality Assurance')
# Department.create(name: 'Insurance')
# Department.create(name: 'Licenses')
# Department.create(name: 'Operations')
# Department.create(name: 'Customers')
# Department.create(name: 'Staff')
# Department.create(name: 'Customer Services')
# Department.create(name: 'Client Services')
# Department.create(name: 'Research & Development')
# Department.create(name: 'Market Development')
# Department.create(name: 'Business Development')
# Department.create(name: 'Management')
# Department.create(name: 'Engineering')

m_first_names = %w[JAMES, JOHN, ROBERT, MICHAEL, WILLIAM, DAVID, RICHARD, CHARLES, JOSEPH, THOMAS, CHRISTOPHER, DANIEL, PAUL, MARK, DONALD, GEORGE, KENNETH, STEVEN, EDWARD, BRIAN, RONALD, ANTHONY, KEVIN, JASON, MATTHEW, GARY, TIMOTHY, JOSE, LARRY, JEFFREY]
f_first_names = %w[MARY, PATRICIA, LINDA, BARBARA, ELIZABETH, JENNIFER, MARIA, SUSAN, MARGARET, DOROTHY, LISA, NANCY, KAREN, BETTY, HELEN, SANDRA, DONNA, CAROL, RUTH, SHARON, MICHELLE, LAURA, SARAH, KIMBERLY, DEBORAH, JESSICA, SHIRLEY, CYNTHIA, ANGELA, MELISSA]
last_names = %w[SMITH, JOHNSON, WILLIAMS, JONES, BROWN, DAVIS, MILLER, WILSON, MOORE, TAYLOR, ANDERSON, THOMAS, JACKSON, WHITE, HARRIS, MARTIN, THOMPSON, GARCIA, MARTINEZ, ROBINSON, CLARK, RODRIGUEZ, LEWIS, LEE, WALKER, HALL, ALLEN, YOUNG, HERNANDEZ, KING]

User.create(username: "launchboard", email: "info@launchboard.com",
            password: "launchboard", password_confirmation: "launchboard",
            admin: true, first_name: "LaunchBoard", last_name: "Admin",
            job_title: "System Admin")

# demo company
demo_comp  =  Organization.create(name: "Demo Company Inc.", activated: true)
demoman_comp  = User.create(username: "demoman_comp", email: "comp_man@demo.com",
                  password: "demoman_comp", password_confirmation: "demoman_comp",
                  first_name: "John", last_name: "Manager",
                  job_title: "Manager", organization_id: 1, manager: true)

# demo association
demo_assoc =  Organization.create(name: "Demo Association Inc.", activated: true)
demoman_assoc = User.create(username: "demoman_assoc", email: "assoc_man@demo.com",
                  password: "demoman_assoc", password_confirmation: "demoman_assoc",
                  first_name: "Jeff", last_name: "Manager",
                  job_title: "Manager", organization_id: 1, manager: true)

# demo personnel for demo_comp
16.times do |i|
  sex = (i % 2 == 0) ? 'f' : 'm'
  fist_name = (i % 2 == 0) ? f_first_names[i/2] : m_first_names[i/2]
  last_name = (i % 2 == 0) ? f_last_names[i/2] : m_last_names[i/2]
  user_name = first_name[0] + last_name + '_comp'
  user = User.create(username: user_name, email: "#{user_name}@demo.com",
              password: user_name, password_confirmation: user_name,
              first_name: first_name.capitalize,
              last_name: last_name.capitalize,
              job_title: "Employee", organization_id: demo_comp.id)
  Picture.create({
    user_id: user.id,
    image: File.new("#{Rails.root}/app/assets/seeds/demo_users/User #{i/2}#{sex}.png"),
  })
end

# demo personnel for demo_assoc
16.times do |i|
  sex = (i % 2 == 0) ? 'f' : 'm'
  fist_name = (i % 2 == 0) ? f_first_names[i/2] : m_first_names[i/2]
  last_name = (i % 2 == 0) ? f_last_names[i/2] : m_last_names[i/2]
  user_name = first_name[0] + last_name + '_assoc'
  user = User.create(username: user_name, email: "#{user_name}@demo.com",
              password: user_name, password_confirmation: user_name,
              first_name: first_name.capitalize,
              last_name: last_name.capitalize,
              job_title: "Employee", organization_id: demo_assoc.id)
  Picture.create({
    user_id: user.id,
    image: File.new("#{Rails.root}/app/assets/seeds/demo_users/User #{i/2}#{sex}.png"),
  })
end

# sample departments comp
DepartmentEntry.create(department_name: 'Marketing', context: demo_comp)
DepartmentEntry.create(department_name: 'Operations', context: demo_comp)
DepartmentEntry.create(department_name: 'Sales', context: demo_comp)
DepartmentEntry.create(department_name: 'Engineering', context: demo_comp)
DepartmentEntry.create(department_name: 'Quality Assurance', context: demo_comp)
DepartmentEntry.create(department_name: 'Human Resources', context: demo_comp)
User.where(organization_id: demo_comp.id).each do |u|
  # count = demo_comp.department_entries.count
  # index = u.id % count
  demo_comp.department_entries.each do |department_entry|
    DepartmentEntryMembership.create(department_entry: department_entry, user: u)
  end
end

# sample departments assoc
DepartmentEntry.create(department_name: 'Football Club', context: demo_assoc)
DepartmentEntry.create(department_name: 'Hockey Club', context: demo_assoc)
DepartmentEntry.create(department_name: 'Lacrosse Club', context: demo_assoc)
DepartmentEntry.create(department_name: 'Salsa Club', context: demo_assoc)
DepartmentEntry.create(department_name: 'Yoga Club', context: demo_assoc)
User.where(organization_id: demo_assoc.id).each do |u|
  # count = demo_assoc.department_entries.count
  # index = u.id % count
  demo_assoc.department_entries.each do |department_entry|
    DepartmentEntryMembership.create(department_entry: department_entry, user: u)
  end
end

# ------------ BEGIN POSTS COMP ------------
# ------------ END POSTS COMP --------------


# ------------ BEGIN POSTS ASSOC -----------
# ------------ END POSTS ASSOC -------------


# # demo posts
# 3.times do |type|
#   post_type = "Project" if type == Post::PROJECT
#   post_type = "Fun" if type == Post::FUN
#   post_type = "Facility" if type == Post::FACILITY

#   # archived
#   Post.create(title: "Archived #{post_type} Post",
#               content: Forgery(:lorem_ipsum).words(34).capitalize,
#               threshold: 20,
#               graveyard: true,
#               user_id: 2 + rand(30),
#               organization_id: 1,
#               post_type: type)

#   # downvoted
#   terrible = Post.create(title: "Terrible #{post_type} Post",
#               content: Forgery(:lorem_ipsum).words(34).capitalize,
#               threshold: 20,
#               user_id: 2 + rand(30),
#               organization_id: 1,
#               post_type: type)
#   15.times do |uid|
#     Opinion.create(opinionable_id: terrible.id, opinionable_type: "Post",
#                    positive: false, user_id: 10 + uid)
#   end
#   terrible.update(opinion: -15)

#   # upvoted, two plain comments, 1 suggestion
#   trending = Post.create(title: "Trending #{post_type} Post",
#               content: Forgery(:lorem_ipsum).words(34).capitalize,
#               threshold: 20,
#               user_id: 2 + rand(30),
#               organization_id: 1,
#               post_type: type)
#   15.times do |uid|
#     Opinion.create(opinionable_id: trending.id, opinionable_type: "Post",
#                    positive: true, user_id: 10 + uid)
#   end
#   trending.update(opinion: 15)
#   2.times do |c|
#     Comment.create(commentable_id: trending.id, commentable_type: "Post", user_id: 2 + rand(30),
#                    content: "Plain old comment, nothing special.", suggestion: false)
#   end
#   Comment.create(commentable_id: trending.id, commentable_type: "Post", user_id: 2 + rand(30),
#                  content: "Alternative solution here!", suggestion: true)

#   # doit (post), one plain comment
#   doit = Post.create(title: "Launch #{post_type} Post",
#               content: Forgery(:lorem_ipsum).words(34).capitalize,
#               threshold: 20,
#               user_id: 2 + rand(30),
#               organization_id: 1,
#               post_type: type)
#   30.times do |uid|
#     Opinion.create(opinionable_id: doit.id, opinionable_type: "Post",
#                    positive: true, user_id: 10 + uid)
#   end
#   doit.update(opinion: 30)
#   Comment.create(commentable_id: doit.id, commentable_type: "Post", user_id: 2 + rand(30),
#                  content: "Great idea!", suggestion: false)

#   # doit (alt), three plain comment, two suggestions (one doit)
#   alt_doit = Post.create(title: "Alt Launch #{post_type} Post",
#               content: Forgery(:lorem_ipsum).words(34).capitalize,
#               threshold: 20,
#               user_id: 2 + rand(30),
#               organization_id: 1,
#               post_type: type)
#   10.times do |uid|
#     Opinion.create(opinionable_id: alt_doit.id, opinionable_type: "Post",
#                    positive: true, user_id: 10 + uid)
#   end
#   alt_doit.update(opinion: 10)
#   3.times do |c|
#     Comment.create(commentable_id: alt_doit.id, commentable_type: "Post", user_id: 2 + rand(30),
#                    content: "Plain old comment, nothing special.", suggestion: false)
#   end
#   doit_com = Comment.create(commentable_id: alt_doit.id, commentable_type: "Post", user_id: 2 + rand(30),
#                             content: "Alternative solution 1!", suggestion: true)
#   Comment.create(commentable_id: alt_doit.id, commentable_type: "Post", user_id: 2 + rand(30),
#                  content: "Alternative solution 2!", suggestion: true)
#   35.times do |uid|
#     Opinion.create(opinionable_id: doit_com.id, opinionable_type: "Comment",
#                    positive: true, user_id: 10 + uid)
#   end
#   doit_com.update(opinion: 35)
# end

# # ECL Demo
# Organization.create(name: "ECL Inc.", activated: true)
# User.create(username: "ecldemo", email: "info@ecl.com",
#             password: "ecldemo", password_confirmation: "ecldemo",
#             first_name: "ECL", last_name: "Manager",
#             job_title: "Manager", organization_id: 2, manager: true)
