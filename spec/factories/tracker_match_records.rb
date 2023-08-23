FactoryBot.define do
  factory :tracker_match_record do
    match_date { "2023-08-09 12:09:21" }
    legend { "MyString" }
    kills { 1 }
    wins { 1 }
  end
end
