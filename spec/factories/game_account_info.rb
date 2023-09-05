FactoryBot.define do
  factory :game_account_info do
    platform { "origin" }
    gameid { "Twitch_Ne1u" }
    association :user
  end
end
