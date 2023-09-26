class UsersController < ApplicationController
  PERCENTAGE_BASE = 100

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @game_account_info = @user.game_account_info
    game_account_check
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = 'ユーザーを削除しました。'
    redirect_to root_path
  end

  private

  def game_account_check
    if @game_account_info.blank?
      @trn_player_stats = "No account"
    else
      @trn_player_stats = TrackerApiService.fetch_trn_player_stats(@game_account_info)
      if @trn_player_stats.include?("data")
        fetch_trn_player_stats
      else
        return @trn_player_stats
      end
    end
  end

  def fetch_trn_player_stats
    fetch_trn_overall_stats
    fetch_trn_current_season_stats
    fetch_trn_legend_stats
    current_rank
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
    @trn_current_season = TrackerApiService.fetch_current_season(@trn_player_stats)
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

  def current_rank
    @trn_rank_name = @trn_player_stats.dig("data", "segments", 0, "stats", "rankScore", "metadata", "rankName")
    @user.game_account_info.update(current_rank:@trn_rank_name)
    value = nil
    rank = TrackerApiService.overall_stat_rank(@trn_player_stats, "rankScore")
    percentile = TrackerApiService.overall_stat_percentile(@trn_player_stats, "rankScore")
    set_trn_instance_variables("rank", "point", value, rank, percentile)
  end

  def set_trn_instance_variables(prefix, segment, value, rank, percentile)
    instance_variable_set("@trn_#{prefix}_#{segment}_value", value)
    instance_variable_set("@trn_#{prefix}_#{segment}_rank", rank)
    instance_variable_set("@trn_#{prefix}_#{segment}_percentile", percentile)
  end

  def value_check(value1, value2)
    value1 == "---" || value2 == "---" ? "---" : yield
  end
end
