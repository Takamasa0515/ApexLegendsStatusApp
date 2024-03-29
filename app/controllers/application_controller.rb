class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_q, :search

  def search
    @users_result = @q.result
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name self_introduction avatar])
  end

  def after_sign_in_path_for(_resource_or_scope)
    user_path(current_user)
  end

  def after_sign_out_path_for(_resource_or_scope)
    root_path
  end

  def after_update_path_for(_resource_or_scope)
    user_path(current_user)
  end

  def set_q
    @q = User.ransack(params[:q])
  end
end
