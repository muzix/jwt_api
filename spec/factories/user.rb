FactoryBot.define do
  factory :user do
    username { Faker::Internet.username }
    password  { "password" }
    email { Faker::Internet.email }
  end
end
