class Users::RegistrationsController < Devise::RegistrationsController
  before_action :ensure_normal_user, only: %i[update destroy]

  def after_update_path_for(_resource)
    user_path(current_user.id)
  end

  def ensure_normal_user
    return unless resource.email == "guest@example.com"

    redirect_to user_path(current_user.id), alert: "ゲストユーザーの更新・削除はできません。"
  end
end
