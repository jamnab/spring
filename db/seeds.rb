require 'csv'

m_first_names = %w[JAMES JOHN ROBERT MICHAEL WILLIAM DAVID RICHARD CHARLES JOSEPH THOMAS CHRISTOPHER DANIEL PAUL MARK DONALD GEORGE KENNETH STEVEN EDWARD BRIAN RONALD ANTHONY KEVIN JASON MATTHEW GARY TIMOTHY JOSE LARRY JEFFREY]
f_first_names = %w[MARY PATRICIA LINDA BARBARA ELIZABETH JENNIFER MARIA SUSAN MARGARET DOROTHY LISA NANCY KAREN BETTY HELEN SANDRA DONNA CAROL RUTH SHARON MICHELLE LAURA SARAH KIMBERLY DEBORAH JESSICA SHIRLEY CYNTHIA ANGELA MELISSA]
last_names = %w[SMITH JOHNSON WILLIAMS JONES BROWN DAVIS MILLER WILSON MOORE TAYLOR ANDERSON THOMAS JACKSON WHITE HARRIS MARTIN THOMPSON GARCIA MARTINEZ ROBINSON CLARK RODRIGUEZ LEWIS LEE WALKER HALL ALLEN YOUNG HERNANDEZ KING]

User.create(username: "launchboard", email: "info@launchboard.com",
            password: "launchboard", password_confirmation: "launchboard",
            admin: true, first_name: "Launchboard", last_name: "Admin",
            job_title: "System Admin")

# demo company
demo_comp  =  Organization.create(name: "Demo Company Inc.", activated: true)
demoman_comp  = User.create(username: "demoman_comp", email: "comp_man@demo.com",
                  password: "demoman_comp", password_confirmation: "demoman_comp",
                  first_name: "John", last_name: "Manager",
                  job_title: "Manager", organization_id: demo_comp.id, manager: true)

# demo association
demo_assoc =  Organization.create(name: "Demo Association Inc.", activated: true)
demoman_assoc = User.create(username: "demoman_assoc", email: "assoc_man@demo.com",
                  password: "demoman_assoc", password_confirmation: "demoman_assoc",
                  first_name: "Jeff", last_name: "Manager",
                  job_title: "Manager", organization_id: demo_assoc.id, manager: true)

# demo personnel for demo_comp
16.times do |i|
  sex = (i % 2 == 0) ? 'f' : 'm'
  first_name = (i % 2 == 0) ? f_first_names[i/2].camelize : m_first_names[i/2].camelize
  last_name = last_names[i/2].camelize
  user_name = first_name[0].downcase + last_name.downcase + '_comp'
  user = User.create(username: user_name, email: "#{user_name}@demo.com",
              password: user_name, password_confirmation: user_name,
              first_name: first_name.capitalize,
              last_name: last_name.capitalize,
              job_title: "Employee", organization_id: demo_comp.id)
  Picture.create({
    user_id: user.id,
    image: File.new("#{Rails.root}/app/assets/seeds/demo_users/User #{i/2+1}#{sex}.png"),
  })
end

# demo personnel for demo_assoc
16.times do |i|
  sex = (i % 2 == 0) ? 'f' : 'm'
  first_name = (i % 2 == 0) ? f_first_names[i/2].camelize : m_first_names[i/2].camelize
  last_name = last_names[i/2].camelize
  user_name = first_name[0].downcase + last_name.downcase + '_assoc'
  user = User.create(username: user_name, email: "#{user_name}@demo.com",
              password: user_name, password_confirmation: user_name,
              first_name: first_name.capitalize,
              last_name: last_name.capitalize,
              job_title: "Employee", organization_id: demo_assoc.id)
  Picture.create({
    user_id: user.id,
    image: File.new("#{Rails.root}/app/assets/seeds/demo_users/User #{i/2+1}#{sex}.png"),
  })
end

# sample departments comp
marketing_de    = DepartmentEntry.create(department_name: 'Marketing', context: demo_comp)
operations_de   = DepartmentEntry.create(department_name: 'Operations', context: demo_comp)
sales_de        = DepartmentEntry.create(department_name: 'Sales', context: demo_comp)
engineering_de  = DepartmentEntry.create(department_name: 'Engineering', context: demo_comp)
qa_de           = DepartmentEntry.create(department_name: 'Quality Assurance', abbrev_name: 'QA', context: demo_comp)
hr_de           = DepartmentEntry.create(department_name: 'Human Resources', abbrev_name: 'HR', context: demo_comp)
rnd_de          = DepartmentEntry.create(department_name: 'Research & Development', abbrev_name: 'R&D', context: demo_comp)
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
marketing_actionables_csv = File.read('app/assets/seeds/marketing_actionables.csv')
@marketing_actionables = CSV.parse(marketing_actionables_csv, {col_sep: ';'})
marketing_fillers_csv = File.read('app/assets/seeds/marketing_fillers.csv')
@marketing_fillers = CSV.parse(marketing_fillers_csv, {col_sep: ';'})

operations_actionables_csv = File.read('app/assets/seeds/operations_actionables.csv')
@operations_actionables = CSV.parse(operations_actionables_csv, {col_sep: ';'})
operations_fillers_csv = File.read('app/assets/seeds/operations_fillers.csv')
@operations_fillers = CSV.parse(operations_fillers_csv, {col_sep: ';'})

sales_actionables_csv = File.read('app/assets/seeds/sales_actionables.csv')
@sales_actionables = CSV.parse(sales_actionables_csv, {col_sep: ';'})
sales_fillers_csv = File.read('app/assets/seeds/sales_fillers.csv')
@sales_fillers = CSV.parse(sales_fillers_csv, {col_sep: ';'})

engineering_actionables_csv = File.read('app/assets/seeds/engineering_actionables.csv')
@engineering_actionables = CSV.parse(engineering_actionables_csv, {col_sep: ';'})
engineering_fillers_csv = File.read('app/assets/seeds/engineering_fillers.csv')
@engineering_fillers = CSV.parse(engineering_fillers_csv, {col_sep: ';'})

hr_actionables_csv = File.read('app/assets/seeds/hr_actionables.csv')
@hr_actionables = CSV.parse(hr_actionables_csv, {col_sep: ';'})
hr_fillers_csv = File.read('app/assets/seeds/hr_fillers.csv')
@hr_fillers = CSV.parse(hr_fillers_csv, {col_sep: ';'})

qa_actionables_csv = File.read('app/assets/seeds/qa_actionables.csv')
@qa_actionables = CSV.parse(qa_actionables_csv, {col_sep: ';'})
qa_fillers_csv = File.read('app/assets/seeds/qa_fillers.csv')
@qa_fillers = CSV.parse(qa_fillers_csv, {col_sep: ';'})

rnd_actionables_csv = File.read('app/assets/seeds/rnd_actionables.csv')
@rnd_actionables = CSV.parse(rnd_actionables_csv, {col_sep: ';'})
rnd_fillers_csv = File.read('app/assets/seeds/rnd_fillers.csv')
@rnd_fillers = CSV.parse(rnd_fillers_csv, {col_sep: ';'})

actionable_posts_by_department = [
  {
    department_entry: marketing_de,
    posts: @marketing_actionables
  },
  {
    department_entry: operations_de,
    posts: @operations_actionables
  },
  {
    department_entry: sales_de,
    posts: @sales_actionables
  },
  {
    department_entry: engineering_de,
    posts: @engineering_actionables
  },
  {
    department_entry: hr_de,
    posts: @hr_actionables
  },
  {
    department_entry: qa_de,
    posts: @qa_actionables
  },
  {
    department_entry: rnd_de,
    posts: @rnd_actionables
  }
]

filler_posts_by_department = [
  {
    department_entry: marketing_de,
    posts: @marketing_fillers
  },
  {
    department_entry: operations_de,
    posts: @operations_fillers
  },
  {
    department_entry: sales_de,
    posts: @sales_fillers
  },
  {
    department_entry: engineering_de,
    posts: @engineering_actionables
  },
  {
    department_entry: hr_de,
    posts: @hr_fillers
  },
  {
    department_entry: qa_de,
    posts: @qa_fillers
  },
  {
    department_entry: rnd_de,
    posts: @rnd_fillers
  }
]

actionable_posts_by_department.each do |de_post_set|
  de = de_post_set[:department_entry]
  posts = de_post_set[:posts]
  posts.each do |post|
    rand_uid = rand(16)
    user = de.users[rand_uid]
    new_post = Post.create(title: post[0], content: post[1],
                           user: user,
                           approved: true,
                           launch_approved: true,
                           organization: demo_comp)
    # post[2] is image
    Picture.create({
      post_id: new_post.id,
      image: File.new("#{Rails.root}/app/assets/seeds/images/#{post[2]}"),
    })
    PostDepartmentEntry.create(post: new_post, department_entry: de)
    # random > 75% support
    num_votes = rand(10..15)
    num_votes.times do |uid|
      Opinion.create(opinionable: new_post,
                     positive: true, user: de.users[uid])
    end
    new_post.update(opinion: num_votes)
  end
end

filler_posts_by_department.each do |de_post_set|
  de = de_post_set[:department_entry]
  posts = de_post_set[:posts]
  posts.each do |post|
    rand_uid = rand(16)
    user = de.users[rand_uid]
    new_post = Post.create(title: post[0], content: post[1],
                           user: user,
                           approved: true, organization: demo_comp)
    PostDepartmentEntry.create(post: new_post, department_entry: de)
    # random < 75% support
    num_votes = rand(10)
    num_votes.times do |uid|
      Opinion.create(opinionable: new_post,
                     positive: true, user: de.users[uid])
    end
    new_post.update(opinion: num_votes)
  end
end
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
