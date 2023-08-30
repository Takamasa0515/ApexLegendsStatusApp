module TrackerMatchRecordsHelper
  def current_month_kills(matches)
    binding.pry
  end

  def match_id(date)
    results = match_results(date)
    ids = []
    results.each do |result|
      ids << result.id
    end
  end

  def match_kills(date)
    results = match_results(date)
    kills = []
    results.each do |result|
      kills << result.kills
    end
    kills.sum
  end

  def match_results(date)
    @matches.where(match_date: date.all_day)
  end
end
