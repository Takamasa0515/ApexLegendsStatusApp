crumb :root do
  link "Home", root_path
end

crumb :sign_up do
  link "新規登録", new_user_registration_path
  parent :root
end

crumb :log_in do
  link "ログイン", new_user_session_path
  parent :root
end

crumb :users do |user|
  link "ユーザー一覧", users_path
  parent :root
end

crumb :user_show do |user|
  if user_signed_in? && user.id == current_user.id
    link "マイページ", user_path(user)
  else
    link user.name.to_s, user_path(user)
  end
  parent :users
end

crumb :user_edit do |user|
  link "アカウント編集", edit_user_registration_path
  parent :user_show, user
end

crumb :new_user_password do
  link "パスワード再設定メール送信", new_user_password_path
  parent :log_in
end

crumb :edit_user_password do
  link "パスワード再設定", edit_user_password_path
  parent :root
end

crumb :game_account_info_edit do |user|
  link "ゲームアカウント登録・編集", edit_game_account_info_path
  parent :user_show, user
end

crumb :user_match_record do |user|
  link "試合履歴", user_tracker_match_records_path(user)
  parent :user_show, user
end

crumb :search do
  link "ユーザー検索", search_users_path
  parent :root
end

crumb :contact do
  link "お問い合わせ", new_contact_path
  parent :root
end

crumb :confirm do
  link "確認画面", confirm_path
  parent :contact
end

crumb :complete do
  link "送信完了", complete_path
  parent :contact
end
