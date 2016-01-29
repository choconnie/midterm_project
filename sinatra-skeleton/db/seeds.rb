require 'faker'

# If you are using 'rake db:rollback', then be careful.
# Once you create data, comments all out.
# Or
# rake db:drop       # erase all the tables
# rake db:migrate    # migrate again
# rake db:seed       # put data into table
# and then check your database


# Create Admin user
# user = User.create!(
#   username: 'admin',
#   password: '12345678',
#   email: 'admin@usc.ca'
# )

##########################################
##  Change this numbers to generate things as much as you want

NUMBER_OF_USERS    = 5
NUMBER_OF_GROUPS   = 3
NUMBER_OF_POSTS    = 10
NUMBER_OF_COMMENTS = 15
NUMBER_OF_SERVICES = 4
NUMBER_OF_EVENTS   = 7
NUMBER_OF_ANNOUNCEMENTS = 5

##########################################


# # Create users
NUMBER_OF_USERS.times do
  User.create!(
    username: Faker::Internet.user_name,
    password: Faker::Internet.password(8, 15, true, true),
    email:    Faker::Internet.email
  )
end

# # Create groups
NUMBER_OF_GROUPS.times do
  Group.create!(
    group_name: Faker::Team.name,
    city:       Faker::Address.city
  )
end

# # Create memberships
NUMBER_OF_USERS.times do
  Membership.create!(
    user_id: Faker::Number.between(1, NUMBER_OF_USERS),
    group_id: Faker::Number.between(1, NUMBER_OF_GROUPS)
  )
end


# # Create posts
NUMBER_OF_POSTS.times do
  Post.create!(
    title:    Faker::App.name,
    content:  Faker::Lorem.paragraph,
    group_id: Faker::Number.between(1, NUMBER_OF_GROUPS)
  )
end

# # Create comments
NUMBER_OF_COMMENTS.times do
  Comment.create!(
    content: Faker::Hipster.sentence,
    post_id: Faker::Number.between(1, NUMBER_OF_POSTS)
  )
end

# # Create services
NUMBER_OF_SERVICES.times do
  Service.create!(
    title:   Faker::App.name,
    content: Faker::Hipster.sentence(3),
    email:   Faker::Internet.email,
    phone:   Faker::PhoneNumber.cell_phone
  )
end

# # Create events
NUMBER_OF_EVENTS.times do
  Event.create!(
    title:      Faker::App.name,
    event_date: Faker::Date.forward(30),
    location:   Faker::Address.street_address,
    url:        Faker::Internet.url('example.com'),
    post_id:    Faker::Number.between(1, NUMBER_OF_POSTS)
  )
end

# # Create announcements 
NUMBER_OF_ANNOUNCEMENTS.times do
  Announcement.create!(
    title:      Faker::App.name,
    content:    Faker::Hipster.sentence(4)
  )
end