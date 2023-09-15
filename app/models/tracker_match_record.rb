class TrackerMatchRecord < ApplicationRecord
  belongs_to :user

  require 'httpclient'
  def self.fetch_trn_match_history(game_account_info)
    client = HTTPClient.new
    headers = { 'TRN-Api-Key' => ENV.fetch('TRN_API_KEY', nil) }
    url = "https://public-api.tracker.gg/v2/apex/standard/profile/#{game_account_info.platform}/#{game_account_info.gameid}/sessions"
    result = JSON.parse(client.get(url, header: headers).body)
    if result.include?("errors")
      "No account"
    elsif result["message"] == "API rate limit exceeded"
      "Apilimit"
    else
      result
    end
  end

  def self.save_past_match_histories(match_histories, user)
    history_span = ((Time.zone.today - 2.months).beginning_of_month..Time.zone.today).to_a
    history_span.each do |day|
      day_history = fetch_day_match_history(match_histories, day)
      next if day_history.blank?

      results = fetch_match_result(day_history)
      results.each do |result|
        result_date = Date.parse(result["date"])
        TrackerMatchRecord.create!(user: user, match_date: result["date"], legend: result["legend"], kills: result["kills"], damages: result["damages"], wins: result["wins"]) unless TrackerMatchRecord.exists?(user: user, match_date: result["date"], legend: result["legend"], kills: result["kills"], damages: result["damages"], wins: result["wins"])
      end
    end
  end

  def self.fetch_day_match_history(match_histories, day)
    match_histories["data"]["items"].select do |history|
      end_date_value = history["metadata"]["endDate"]["value"]
      end_date_value.include?(day.to_s)
    end
  end

  def self.fetch_match_result(day_history)
    match_results = []
    day_history.each do |match_group|
      match_group["matches"].each do |match|
        match_results << extract_match_result(match)
      end
    end
    match_results
  end

  def self.extract_match_result(match)
    match_date = match["metadata"]["endDate"]["value"]
    legend = match["metadata"]["character"]["displayValue"]
    kills = match["stats"]["kills"].present? ? match["stats"]["kills"]["value"] : 0
    damages = match["stats"]["damage"].present? ? match["stats"]["damage"]["value"] : 0
    wins = match["stats"]["wins"].present? ? match["stats"]["wins"]["value"] : 0
    { "date" => match_date, "legend" => legend, "kills" => kills, "damages" => damages, "wins" => wins }
  end
end
