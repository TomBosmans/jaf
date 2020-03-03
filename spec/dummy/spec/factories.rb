FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email  { Faker::Internet.email(name: name, separators: '.') }
  end

  factory :list do
    name { Faker::Company.buzzword }
    user
  end

  factory :todo do
    description { Faker::Company.catch_phrase }
    list
  end
end
