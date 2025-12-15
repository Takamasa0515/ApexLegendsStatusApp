class UpdateGuestUserParameters < ActiveRecord::Migration[7.0]
  def up
    guest = User.find_by(email: "guest@example.com")
    return unless guest

    game_account = guest.game_account_info
    game_account.update!(
      gameid: "lNe1u",
    )
  end

  def down
    guest = User.find_by(email: "guest@example.com")
    return unless guest

    game_account = guest.game_account_info
    game_account.update!(
      gameid: "Twitch_Ne1u",
    )
  end
end
