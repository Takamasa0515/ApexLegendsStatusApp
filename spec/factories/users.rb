FactoryBot.define do
  factory :user do
    name { "test" }
    email { "test@example.com" }
    password { "testpassword" }
  end

  factory :game_account_info do
    platform { "origin" }
    gameid { "Twitch_Ne1u" }
  end
end
