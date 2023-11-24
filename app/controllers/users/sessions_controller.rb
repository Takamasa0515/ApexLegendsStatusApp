module Users
  class SessionsController < Devise::SessionsController
    def guest_sign_in
      user = User.guest
      binding.pry
      sign_in user
      redirect_to root_path, notice: 'ゲストユーザーとしてログインしました。'
    end
  end
end
