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

crumb :users  do |user|
  link "ユーザー一覧", users_path
  parent :root
end

crumb :user_show do |user|
  if user_signed_in? && user.id == current_user.id
    link "マイページ", user_path(user)
  else
    link "#{user.name}", user_path(user)
  end
  parent :users
end

crumb :search do
  link "ユーザー検索", search_users_path
  parent :root
end
