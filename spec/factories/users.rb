FactoryBot.define do
  factory :user do
    name { "test" }
    email { "test@example.com" }
    password { "testpassword" }
    self_introduction { "テストデータです" }
  end

  factory :guest_user, class: "User" do
    name { "ゲストアカウント" }
    email { "guest@example.com" }
    password { "ゲストユーザーのパスワード" }
    self_introduction { "ゲストユーザーです" }
  end

end
