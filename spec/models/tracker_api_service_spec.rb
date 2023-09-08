require 'rails_helper'

RSpec.describe TrackerApiService, type: :model do
  let(:overall_data) do {
      "data" => {
        "segments" =>[
          { "stats" => {
              "level" => { "rank" => 10000, "percentile" => 50.0, "value" => 1000 },
              "kills" => { "rank" => 150, "percentile" => 99.9, "value" => 20000 },
              "damage" => { "rank" => 2000, "percentile" => 99.8, "value" => 250000000 },
              "matchesPlayed" => { "rank" => 5000, "percentile" => 5.00, "value" => 5000 },
              "wins" => { "rank" => 3000, "percentile" => 10.0, "value" => 25 },
              "killsAsKillLeader" => { "rank" => 20000, "percentile" => 60.0, "value" => 30 }
            }
          }
        ]
      }
    }
  end

  let(:no_overall_data) do {
    "data" => {
      "segments" => [
        { "stats" => {
            "level" => { "rank" => {}, "percentile" => {}, "value" => {} },
            }
          }
        ]
      }
    }
  end

  describe "API通信でデータを取得した時" do
    context "総合戦績を抽出する場合" do
      it "levelのvalueが取得できている事" do
        value = TrackerApiService.overall_stat_value(overall_data, "level")
        expect(value).to eq "1,000"
      end

      it "levelのrankが取得できている事" do
        rank = TrackerApiService.overall_stat_rank(overall_data, "level")
        expect(rank).to eq "10,000"
      end

      it "levelのpercentileを取得し、TOPx%に変化できている事" do
        percentile = TrackerApiService.overall_stat_percentile(overall_data, "level")
        expect(percentile).to eq "50.0%"
      end

      it "killsのvalueが取得できている事" do
        value = TrackerApiService.overall_stat_value(overall_data, "kills")
        expect(value).to eq "20,000"
      end

      it "killsのrankが取得できている事" do
        rank = TrackerApiService.overall_stat_rank(overall_data, "kills")
        expect(rank).to eq "150"
      end

      it "killsのpercentileを取得し、TOPx%に変化できている事" do
        percentile = TrackerApiService.overall_stat_percentile(overall_data, "kills")
        expect(percentile).to eq "0.1%"
      end

      it "damageのvalueが取得できている事" do
        value = TrackerApiService.overall_stat_value(overall_data, "damage")
        expect(value).to eq "250,000,000"
      end

      it "damageのrankが取得できている事" do
        rank = TrackerApiService.overall_stat_rank(overall_data, "damage")
        expect(rank).to eq "2,000"
      end

      it "damageのpercentileを取得し、TOPx%に変化できている事" do
        percentile = TrackerApiService.overall_stat_percentile(overall_data, "damage")
        expect(percentile).to eq "0.2%"
      end

      it "matchesPlayedのvalueが取得できている事" do
        value = TrackerApiService.overall_stat_value(overall_data, "matchesPlayed")
        expect(value).to eq "5,000"
      end

      it "matchesPlayedのrankが取得できている事" do
        rank = TrackerApiService.overall_stat_rank(overall_data, "matchesPlayed")
        expect(rank).to eq "5,000"
      end

      it "matchesPlayedのpercentileを取得し、TOPx%に変化できている事" do
        percentile = TrackerApiService.overall_stat_percentile(overall_data, "matchesPlayed")
        expect(percentile).to eq "95.0%"
      end

      it "winsのvalueが取得できている事" do
        value = TrackerApiService.overall_stat_value(overall_data, "wins")
        expect(value).to eq "25"
      end

      it "winsのrankが取得できている事" do
        rank = TrackerApiService.overall_stat_rank(overall_data, "wins")
        expect(rank).to eq "3,000"
      end

      it "winsのpercentileを取得し、TOPx%に変化できている事" do
        percentile = TrackerApiService.overall_stat_percentile(overall_data, "wins")
        expect(percentile).to eq "90.0%"
      end

      it "killsAsKillLeaderのvalueが取得できている事" do
        value = TrackerApiService.overall_stat_value(overall_data, "killsAsKillLeader")
        expect(value).to eq "30"
      end

      it "killsAsKillLeaderのrankが取得できている事" do
        rank = TrackerApiService.overall_stat_rank(overall_data, "killsAsKillLeader")
        expect(rank).to eq "20,000"
      end

      it "killsAsKillLeaderのpercentileを取得し、TOPx%に変化できている事" do
        percentile = TrackerApiService.overall_stat_percentile(overall_data, "killsAsKillLeader")
        expect(percentile).to eq "40.0%"
      end

      it "該当要素にvalueの値がない場合、---を返す事" do
        value = TrackerApiService.overall_stat_value(no_overall_data, "level")
        expect(value).to eq "---"
      end

      it "該当要素にrankの値がない場合、---を返す事" do
        rank = TrackerApiService.overall_stat_rank(no_overall_data, "level")
        expect(rank).to eq "---"
      end

      it "該当要素にpercentileの値がない場合、---を返す事" do
        percentile = TrackerApiService.overall_stat_percentile(no_overall_data, "level")
        expect(percentile).to eq "---"
      end
    end
  end
end