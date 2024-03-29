require 'rails_helper'

RSpec.describe TrackerMatchRecord, type: :model do
  let(:user) { FactoryBot.build(:user) }
  let(:saved_match_result) { FactoryBot.create(:tracker_match_record, user:) }

  let(:match_history) do
    { "data" =>
      { "items" =>
        [
          { "metadata" => { "endDate" => { "value" => Time.zone.today.beginning_of_month.to_s } },
            "matches" => [{
              "metadata" => {
                "endDate" => { "value" => Time.zone.today.beginning_of_month.to_s },
                "character" => { "displayValue" => "Wraith" }
              },
              "stats" => {
                "kills" => { "value" => 10 },
                "damage" => { "value" => 1800 },
                "wins" => { "value" => 1 }
              }
            }] }
        ] } }
  end

  let(:extract_day_history) do
    [
      {
        "metadata" => { "endDate" => { "value" => Time.zone.today.beginning_of_month.to_s } },
        "matches" => [
          {
            "metadata" => { "endDate" => { "value" => Time.zone.today.beginning_of_month.to_s }, "character" => { "displayValue" => "Wraith" } },
            "stats" => { "kills" => { "value" => 10 }, "damage" => { "value" => 1800 }, "wins" => { "value" => 1 } }
          }
        ]
      }
    ]
  end

  let(:one_match_history) do
    {
      "metadata" => {
        "endDate" => { "value" => Time.zone.today.beginning_of_month.to_s }, "character" => { "displayValue" => "Wraith" }
      },
      "stats" => {
        "kills" => { "value" => 10 }, "damage" => { "value" => 1800 }, "wins" => { "value" => 1 }
      }
    }
  end

  let(:no_value_one_match_history) do
    {
      "metadata" => {
        "endDate" => { "value" => Time.zone.today.beginning_of_month.to_s }, "character" => { "displayValue" => "Wraith" }
      },
      "stats" => {
        "kills" => { "value" => 10 }, "damage" => { "value" => 1800 }
      }
    }
  end

  let(:extract_one_match_result) do
    { "date" => Time.zone.today.beginning_of_month.to_s, "legend" => "Wraith", "kills" => 10, "damages" => 1800, "wins" => 1 }
  end

  let(:extract_match_result) do
    [{ "date" => Time.zone.today.beginning_of_month.to_s, "legend" => "Wraith", "kills" => 10, "damages" => 1800, "wins" => 1 }]
  end

  describe "API通信でデータを取得した時" do
    context "指定した日にデータがある場合" do
      it "全ての試合履歴が取得できている事" do
        date = Date.new(Time.zone.today.year, Time.zone.today.month, 1)
        day_history = TrackerMatchRecord.fetch_day_match_history(match_history, date)
        expect(day_history).to eq extract_day_history
      end

      it "1日の試合履歴から必要な要素を抽出し、配列として格納できている事" do
        match_result = TrackerMatchRecord.fetch_match_result(extract_day_history)
        expect(match_result).to eq extract_match_result
      end

      it "1つの試合履歴から試合結果を抽出できている事" do
        one_match_result = TrackerMatchRecord.extract_match_result(one_match_history)
        expect(one_match_result).to eq extract_one_match_result
      end

      it "DBにデータがない場合、保存する事" do
        expect do
          TrackerMatchRecord.save_past_match_histories(match_history, user)
        end.to change(TrackerMatchRecord, :count).by(1)
      end

      it "DBにデータがある場合、保存しないこと" do
        saved_match_result
        expect do
          TrackerMatchRecord.save_past_match_histories(match_history, user)
        end.not_to change(TrackerMatchRecord, :count)
      end
    end

    context "指定した日にデータがない場合" do
      it "空を返す事" do
        date = Date.new(2023, 8, 2)
        day_history = TrackerMatchRecord.fetch_day_match_history(match_history, date)
        expect(day_history).to be_blank
      end

      it "試合履歴に必要な要素がない場合、0を返す事" do
        one_match_result = TrackerMatchRecord.extract_match_result(no_value_one_match_history)
        expect(one_match_result["wins"]).to eq 0
      end
    end
  end
end
