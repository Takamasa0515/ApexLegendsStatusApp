class UsersController < ApplicationController
  PERCENTAGE_BASE = 100

  def show
    @user = User.find(params[:id])
    @game_account_info = @user.game_account_info
    @trn_player_stats = TrackerApiService.fetch_trn_player_stats(@game_account_info)

    @trn_overall_segment_stats = ["level", "kills", "damage", "matchesPlayed", "wins", "killsAsKillLeader"]
    @trn_overall_segment_stats.each do |segment|
      instance_variable_set("@trn_overall_#{segment}_value", TrackerApiService.overall_stat_value(@trn_player_stats, segment))
      instance_variable_set("@trn_overall_#{segment}_rank", TrackerApiService.overall_stat_rank(@trn_player_stats, segment))
      instance_variable_set("@trn_overall_#{segment}_percentile", TrackerApiService.overall_stat_percentile(@trn_player_stats, segment))
    end
    @overall_kpm = TrackerApiService.calculate_kpm(@trn_overall_matchesPlayed_value, @trn_overall_kills_value)
    @overall_winrate =TrackerApiService.calculate_winrate(@trn_overall_matchesPlayed_value, @trn_overall_wins_value)

    @trn_current_season = @trn_player_stats["data"]["metadata"]["currentSeason"].to_s
    @trn_current_season_stats = ["Kills", "Wins"]
    @trn_current_season_stats.each do |segment|
      instance_variable_set("@trn_currentseason_#{segment}_value", TrackerApiService.current_season_stat_value(@trn_player_stats, @trn_current_season, segment))
      instance_variable_set("@trn_currentseason_#{segment}_rank", TrackerApiService.current_season_stat_rank(@trn_player_stats, @trn_current_season, segment))
      instance_variable_set("@trn_currentseason_#{segment}_percentile", TrackerApiService.current_season_stat_percentile(@trn_player_stats, @trn_current_season, segment))
    end

    @trn_all_legend_stats = @trn_player_stats["data"]["segments"].select do |value|
      value = value["type"] == "legend"
    end
    @trn_legend_stats = ["kills", "damage", "wins", "matchesPlayed", "killsAsKillLeader"]
    @percentage_base = PERCENTAGE_BASE
  end
end
