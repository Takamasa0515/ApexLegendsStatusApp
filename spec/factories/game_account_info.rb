FactoryBot.define do
  factory :game_account_info do
    platform { "origin" }
    gameid { "Twitch_Ne1u" }
    current_rank { "Master" }
  end

  factory :steam_game_account_info, class: "GameAccountInfo" do
    platform { "steam" }
    gameid { "steam_account" }
    current_rank { "Platinum 4" }
  end

  factory :no_game_account_info, class: "GameAccountInfo" do
    platform { "steam" }
    gameid { "no_account" }
  end

  factory :guest_game_account_info, class: "GameAccountInfo" do
    platform { "origin" }
    gameid { "Twitch_Ne1u" }
    current_rank { "Master" }
  end
end
