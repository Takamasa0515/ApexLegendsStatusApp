class UsersController < ApplicationController
  PERCENTAGE_BASE = 100

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @game_account_info = @user.game_account_info
    if @game_account_info.blank?
      @trn_player_stats = nil
    else
      @trn_player_stats = TrackerApiService.fetch_trn_player_stats(@game_account_info)
      fetch_trn_player_stats if @trn_player_stats.include?("data")
    end
  end

  private

  def fetch_trn_player_stats
    fetch_trn_overall_stats
    fetch_trn_current_season_stats
    fetch_trn_legend_stats
    save_current_rank
    @percentage_base = PERCENTAGE_BASE
  end

  def fetch_trn_overall_stats
    @trn_overall_stats_name = ["level", "kills", "damage", "matchesPlayed", "wins", "killsAsKillLeader"]
    @trn_overall_stats_name.each do |segment|
      value = TrackerApiService.overall_stat_value(@trn_player_stats, segment)
      rank = TrackerApiService.overall_stat_rank(@trn_player_stats, segment)
      percentile = TrackerApiService.overall_stat_percentile(@trn_player_stats, segment)
      set_trn_instance_variables("overall", segment, value, rank, percentile)
    end

    @overall_kpm = value_check(@trn_overall_matchesPlayed_value, @trn_overall_kills_value) do
      TrackerApiService.calculate_kpm(@trn_overall_matchesPlayed_value, @trn_overall_kills_value)
    end

    @overall_winrate = value_check(@trn_overall_matchesPlayed_value, @trn_overall_wins_value) do
      TrackerApiService.calculate_winrate(@trn_overall_matchesPlayed_value, @trn_overall_wins_value)
    end
  end

  def fetch_trn_current_season_stats
    @trn_current_season = @trn_player_stats["data"]["metadata"]["currentSeason"].to_s
    @trn_current_season_stats_name = ["Kills", "Wins"]
    @trn_current_season_stats_name.each do |segment|
      value = TrackerApiService.current_season_stat_value(@trn_player_stats, @trn_current_season, segment)
      rank = TrackerApiService.current_season_stat_rank(@trn_player_stats, @trn_current_season, segment)
      percentile = TrackerApiService.current_season_stat_percentile(@trn_player_stats, @trn_current_season, segment)
      set_trn_instance_variables("currentseason", segment, value, rank, percentile)
    end
  end

  def fetch_trn_legend_stats
    @trn_all_legend_stats = @trn_player_stats["data"]["segments"].select do |value|
      value['type'] == 'legend'
    end
    @trn_legend_stats_name = ["kills", "damage", "wins", "matchesPlayed", "killsAsKillLeader"]
  end

  def set_trn_instance_variables(prefix, segment, value, rank, percentile)
    instance_variable_set("@trn_#{prefix}_#{segment}_value", value)
    instance_variable_set("@trn_#{prefix}_#{segment}_rank", rank)
    instance_variable_set("@trn_#{prefix}_#{segment}_percentile", percentile)
  end

  def save_current_rank
    @game_account_info.rank = @trn_player_stats["data"]["segments"][0]["stats"]["rankScore"]["metadata"]["rankName"]
  end

  def value_check(value1, value2)
    if value1 == "---" || value2 == "---"
      "---"
    else
      yield
    end
  end
end
