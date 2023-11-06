module TrackerMatchRecordsHelper
  def match_id(matches, date)
    results = match_results(matches, date)
    ids = []
    results.each do |result|
      ids << result.id
    end
  end

  def match_kills(matches, date)
    results = match_results(matches, date)
    kills = []
    results.each do |result|
      kills << result.kills
    end
    kills.sum
  end

  def match_results(matches, date)
    matches.where(match_date: date.all_day)
  end
end
