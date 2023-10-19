FactoryBot.define do
  factory :user do
    name { "user" }
    email { "user@example.com" }
    password { "userpassword" }
    self_introduction { "ユーザーです" }
  end

  factory :user2, class: "User" do
    name { "user2" }
    email { "user2@example.com" }
    password { "user2password" }
    self_introduction { "ユーザー2です" }
  end

  factory :guest_user, class: "User" do
    name { "ゲストアカウント" }
    email { "guest@example.com" }
    password { "ゲストユーザーのパスワード" }
    self_introduction { "ゲストユーザーです" }
  end

  factory :registered_user, class: "User" do
    name { "登録済みユーザー" }
    email { "registered_user@example.com" }
    password { "registered_user_password" }
    self_introduction { "登録済みユーザーです" }
  end
end
