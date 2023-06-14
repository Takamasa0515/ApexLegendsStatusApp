class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  private
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :profile, :avatar])
  end

  def after_sign_in_path_for(resource_or_scope)
    user_path(current_user)
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
end
