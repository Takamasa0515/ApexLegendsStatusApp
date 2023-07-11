class GameAccountInfoController < ApplicationController
  before_action :authenticate_user!
  
  def edit
    @game_account_info = GameAccountInfo.find_or_initialize_by(user_id: current_user.id)
  end

  def update
    @game_account_info = GameAccountInfo.find_or_initialize_by(user_id: current_user.id)
    @game_account_info.user_id = current_user.id
    if @game_account_info.update(game_account_info_params)
      flash[:notice] = I18n.t('flash.update')
      redirect_to user_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def game_account_info_params
    params.require(:game_account_info).permit(:platform, :gameid)
  end
end
