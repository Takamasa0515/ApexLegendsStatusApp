class UsersController < ApplicationController
  before_action :authenticate_user!
  PERCENTAGE_BASE = 100

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @game_account_info = @user.game_account_info
    @trn_player_stats = TrackerApiService.fetch_trn_player_stats(@game_account_info)
    if @trn_player_stats["message"] == "API rate limit exceeded"
      @trn_player_stats = "Apilimit"
    elsif @trn_player_stats.nil? || @trn_player_stats.include?("errors")
      @trn_player_stats = nil
    else
      get_trn_overall_segment_stats
      get_trn_current_season_stats
      get_trn_legend_stats
      save_current_rank
      @percentage_base = PERCENTAGE_BASE
    end
  end

  private

  def get_trn_overall_segment_stats
    @trn_overall_segment_stats = ["level", "kills", "damage", "matchesPlayed", "wins", "killsAsKillLeader"]
    @trn_overall_segment_stats.each do |segment|
      value = TrackerApiService.overall_stat_value(@trn_player_stats, segment)
      rank = TrackerApiService.overall_stat_rank(@trn_player_stats, segment)
      percentile = TrackerApiService.overall_stat_percentile(@trn_player_stats, segment)

      instance_variable_set("@trn_overall_#{segment}_value", value)
      instance_variable_set("@trn_overall_#{segment}_rank", rank)
      instance_variable_set("@trn_overall_#{segment}_percentile", percentile)
    end
    @overall_kpm = value_check(@trn_overall_matchesPlayed_value, @trn_overall_kills_value) do
      TrackerApiService.calculate_kpm(@trn_overall_matchesPlayed_value, @trn_overall_kills_value)
    end

    @overall_winrate = value_check(@trn_overall_matchesPlayed_value, @trn_overall_wins_value) do
      TrackerApiService.calculate_winrate(@trn_overall_matchesPlayed_value, @trn_overall_wins_value)
    end
  end

  def get_trn_current_season_stats
    @trn_current_season = @trn_player_stats['data']['metadata']['currentSeason'].to_s
    @trn_current_season_stats = ["Kills", "Wins"]
    @trn_current_season_stats.each do |segment|
      value = TrackerApiService.current_season_stat_value(@trn_player_stats, @trn_current_season, segment)
      rank = TrackerApiService.current_season_stat_rank(@trn_player_stats, @trn_current_season, segment)
      percentile = TrackerApiService.current_season_stat_percentile(@trn_player_stats, @trn_current_season, segment)

      instance_variable_set("@trn_currentseason_#{segment}_value", value)
      instance_variable_set("@trn_currentseason_#{segment}_rank", rank)
      instance_variable_set("@trn_currentseason_#{segment}_percentile", percentile)
    end
  end

  def get_trn_legend_stats
    @trn_all_legend_stats = @trn_player_stats['data']['segments'].select do |value|
      value['type'] == 'legend'
    end
    @trn_legend_stats = ["kills", "damage", "wins", "matchesPlayed", "killsAsKillLeader"]
  end

  def save_current_rank
    @game_account_info.rank = @trn_player_stats['data']['segments'][0]["stats"]["rankScore"]["metadata"]["rankName"]
  end

  def value_check(value1, value2)
    if value1 == "---" || value2 == "---"
      "---"
    else
      yield
    end
  end
end
