FactoryBot.define do
  factory :contact do
    name { "Test" }
    email { "test@example.com" }
    message { "テストメッセージ" }
  end
end
