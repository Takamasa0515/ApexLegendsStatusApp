FactoryBot.define do
  factory :tracker_match_record do
    match_date { "2023-08-01 " }
    legend { "Wraith" }
    kills { 10 }
    damages { 1800 }
    wins { 1 }
  end
end
