User.create!(
  name: "ユーザー1",
  email: "user1@example.com",
  self_introduction: "初期データです。",
  password: "nxwr7077"
)

GameAccountInfo.create!(
  user_id: User.find_by(email: "user1@example.com").id,
  platform: "origin",
  gameid: "Twitch_Ne1u"
)
