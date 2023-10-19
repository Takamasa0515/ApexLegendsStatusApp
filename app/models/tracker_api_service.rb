class TrackerApiService
  require 'httpclient'
  PERCENTAGE_BASE = 100

  def self.fetch_trn_player_stats(game_account_info)
    client = HTTPClient.new
    headers = { 'TRN-Api-Key' => ENV.fetch('TRN_API_KEY', nil) }
    url = "https://public-api.tracker.gg/v2/apex/standard/profile/#{game_account_info.platform}/#{game_account_info.gameid}"
    result = JSON.parse(client.get(url, header: headers).body)
    if result.dig("message") == "API rate limit exceeded"
      "Apilimit"
    elsif
      result.dig("errors", 0, "code") == "CollectorResultStatus::ExternalError" || result.dig("errors", 0, "code") == "CollectorResultStatus::NotFound"
        "No account"
    else
      result
    end
  end

  def self.overall_stat_value(trn_player_stats, overall_segment_stat)
    stat_attribute_check(trn_player_stats, overall_segment_stat, 'value')
  end

  def self.overall_stat_rank(trn_player_stats, overall_segment_stat)
    stat_attribute_check(trn_player_stats, overall_segment_stat, 'rank')
  end

  def self.overall_stat_percentile(trn_player_stats, overall_segment_stat)
    stat_percentile_check(trn_player_stats, overall_segment_stat)
  end

  def self.calculate_kpm(overall_matchesPlayed_value, overall_kills_value)
    result = calculate_ratio(overall_matchesPlayed_value, overall_kills_value)
    if result == "---"
      result
    else
      result.floor(2)
    end
  end

  def self.calculate_winrate(overall_matchesPlayed_value, overall_wins_value)
    calculate_ratio(overall_matchesPlayed_value, overall_wins_value, percentage: true)
  end

  def self.fetch_current_season(trn_player_stats)
    trn_player_stats["data"]["metadata"]["currentSeason"].to_s
  end

  def self.current_season_stat_value(trn_player_stats, trn_current_season, trn_current_season_stat)
    stat_attribute_check(trn_player_stats, "season#{trn_current_season}#{trn_current_season_stat}", 'value')
  end

  def self.current_season_stat_rank(trn_player_stats, trn_current_season, trn_current_season_stat)
    stat_attribute_check(trn_player_stats, "season#{trn_current_season}#{trn_current_season_stat}", 'rank')
  end

  def self.current_season_stat_percentile(trn_player_stats, trn_current_season, trn_current_season_stat)
    stat_percentile_check(trn_player_stats, "season#{trn_current_season}#{trn_current_season_stat}")
  end

  def self.stat_attribute_check(trn_player_stats, segment_stat, attribute)
    if trn_player_stats.dig('data', 'segments', 0, 'stats', segment_stat, attribute).present?
      trn_player_stats['data']['segments'][0]['stats'][segment_stat][attribute].floor.to_fs(:delimited)
    else
      "---"
    end
  end

  def self.stat_percentile_check(trn_player_stats, segment_stat)
    if trn_player_stats.dig('data', 'segments', 0, 'stats', segment_stat, 'value').present?
      value = trn_player_stats['data']['segments'][0]['stats'][segment_stat]['percentile']
      value.present? ? "#{(PERCENTAGE_BASE - value).round(1)}%" : "---"
    else
      "---"
    end
  end

  def self.calculate_ratio(matchesPlayed, attribute, percentage: false)
    if matchesPlayed == "---" || attribute == "---"
      "---"
    else
      ratio = (attribute.delete(',').to_f / matchesPlayed.delete(',').to_f).floor(2)
      percentage ? "#{(ratio * PERCENTAGE_BASE).floor(1)}%" : ratio
    end
  end
end
