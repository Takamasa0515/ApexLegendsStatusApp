class TrackerMatchHistory
  require 'httpclient'
  def self.fetch_trn_match_history(game_account_info)
    client = HTTPClient.new
    headers = { 'TRN-Api-Key' => ENV.fetch('TRN_API_KEY', nil) }
    url = "https://public-api.tracker.gg/v2/apex/standard/profile/#{game_account_info.platform}/#{game_account_info.gameid}/sessions"
    result = JSON.parse(client.get(url, header: headers).body)
    if result["message"] == "API rate limit exceeded"
      "Apilimit"
    else
      result
    end
  end
end
