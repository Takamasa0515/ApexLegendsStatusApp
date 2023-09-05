FactoryBot.define do
  factory :user do
    name { "test" }
    email { "test@example.com" }
    password { "testpassword" }
  end
end
