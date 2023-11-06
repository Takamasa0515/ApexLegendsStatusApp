FactoryBot.define do
  factory :tracker_match_record do
    match_date { Date.today.beginning_of_month.to_s }
    legend { "Wraith" }
    kills { 10 }
    damages { 1800 }
    wins { 1 }
  end
end
