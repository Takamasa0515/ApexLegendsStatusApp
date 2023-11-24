class GameAccountInfoController < ApplicationController
  before_action :authenticate_user!

  def edit
    if current_user.email == "guest@example.com"
      redirect_to user_path(current_user.id), alert: "ゲストアカウントにはゲームアカウントを登録できません。"
    else
      @game_account_info = GameAccountInfo.find_or_initialize_by(user_id: current_user.id)
    end
  end

  def update
    @game_account_info = GameAccountInfo.find_or_initialize_by(user_id: current_user.id)
    if account_match_check
      redirect_to user_path
    elsif @game_account_info.update(game_account_info_params)
      delete_match_record
      flash[:notice] = I18n.t('flash.update')
      redirect_to user_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def account_match_check
    @game_account_info.platform == game_account_info_params[:platform] && @game_account_info.gameid == game_account_info_params[:gameid]
  end

  def delete_match_record
    user = @game_account_info.user
    records = user.tracker_match_records.all
    records.destroy_all
    user.update(last_accessed_at_match_record: nil)
  end

  private

  def game_account_info_params
    params.require(:game_account_info).permit(:platform, :gameid)
  end
end
