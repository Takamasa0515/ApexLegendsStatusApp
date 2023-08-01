class MatchHistoriesController < ApplicationController
  def show
    @user = User.find(params[:id])
    @game_account_info = @user.game_account_info
  end
end
