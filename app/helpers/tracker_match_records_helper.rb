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

  def month_kills(user, start_date)
    start_date = Date.new(start_date.year, start_date.month, 1)
    end_date = start_date.end_of_month
    calculate_kills(user, start_date, end_date)
  end

  def previous_month_kills(user, start_date)
    start_date = Date.new(start_date.year, start_date.month - 1, 1)
    end_date = start_date.end_of_month
    calculate_kills(user, start_date, end_date)
  end

  def calculate_kills(user, start_date, end_date)
    month_matches = TrackerMatchRecord.where(user_id: user.id, match_date: start_date..end_date)
    month_matches.all.sum(:kills)
  end
end
