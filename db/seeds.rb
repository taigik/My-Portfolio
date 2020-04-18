User.create!(name:  "example",
             email: "example@example.com",
             password:              "example",
             password_confirmation: "example",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

User.create!(name:  "example2",
             email: "example2@example2.com",
             password:              "example2",
             password_confirmation: "example2",
             activated: true,
             activated_at: Time.zone.now)

99.times do |n|
  name  = Faker::Name.name
  email = "example#{n*7-3}@example.com"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content) }
end
