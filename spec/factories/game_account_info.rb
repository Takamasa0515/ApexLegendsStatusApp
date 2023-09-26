FactoryBot.define do
  factory :game_account_info do
    platform { "origin" }
    gameid { "Twitch_Ne1u" }
  end

  factory :no_game_account_info, class: "GameAccountInfo" do
    platform { "steam" }
    gameid { "no_account" }
  end
end
