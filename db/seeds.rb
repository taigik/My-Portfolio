User.create!(name:  "example",
             email: "example@example.com",
             password:              "example",
             password_confirmation: "example",
             admin: true)

99.times do |n|
  name  = Faker::Name.name
  email = "example#{n*7-3}@example.com"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end
