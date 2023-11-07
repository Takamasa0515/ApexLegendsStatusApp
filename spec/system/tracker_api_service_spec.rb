require 'rails_helper'

RSpec.describe TrackerApiService, type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:guest_user) { FactoryBot.create(:guest_user) }
  let(:game_account_info) { FactoryBot.create(:game_account_info, user:) }
  let(:no_game_account_info) { FactoryBot.create(:no_game_account_info, user:) }
  let(:tracker_api_service) do
    {
      "data" => {
        "metadata" => { "currentSeason" => 10 },
        "segments" => [
          {
            "stats" => {
              "level" => { "rank" => 25_233, "percentile" => 99.3, "value" => 1557.0 },
              "kills" => { "rank" => 3659, "percentile" => 99.9, "value" => 45_350.0 },
              "killsPerMatch" => { "rank" => nil, "percentile" => 97.4, "value" => 3.96 },
              "killsAsKillLeader" => { "rank" => nil, "percentile" => 99.9, "value" => 3383.0 },
              "damage" => { "rank" => 2190, "percentile" => 99.9, "value" => 12_892_834.0 },
              "matchesPlayed" => { "rank" => nil, "percentile" => 99.3, "value" => 8916.0 },
              "rankScore" => { "rank" => 1008, "percentile" => 99.8, "metadata" => { "rankName" => "Master" }, "value" => 33_770.0 },
              "season10Kills" => { "rank" => nil, "percentile" => 99.1, "value" => 4122.0 },
              "season10Wins" => { "rank" => nil, "percentile" => nil, "value" => nil },
              "wins" => { "rank" => 4285, "percentile" => 99.6, "value" => 1599.0 }
            }
          },
          {
            "type" => "legend",
            "metadata" => { "name" => "Wraith" },
            "stats" => {
              "kills" => { "rank" => 2433, "percentile" => 99.0, "value" => 23_996.0 },
              "killsAsKillLeader" => { "rank" => nil, "percentile" => 91.9, "value" => 965.0 },
              "damage" => { "rank" => 2000, "percentile" => 100.0, "value" => 7_025_561.0 },
              "matchesPlayed" => { "rank" => nil, "percentile" => 99.5, "value" => 7751.0 },
              "wins" => { "rank" => nil, "percentile" => 99.0, "value" => 894.0 }
            }
          },
          {
            "type" => "legend",
            "metadata" => { "name" => "Horizon" },
            "stats" => {
              "kills" => { "rank" => 10_000, "percentile" => 99.1, "value" => 6000.0 },
              "killsAsKillLeader" => { "rank" => nil, "percentile" => 99.9, "value" => 3830.0 },
              "damage" => { "rank" => 14_324, "percentile" => 100.0, "value" => 1_203_407.0 },
              "matchesPlayed" => { "rank" => nil, "percentile" => 99.5, "value" => 10_003.0 },
              "wins" => { "rank" => 42_990, "percentile" => 96.9, "value" => 492.0 }
            }
          }
        ]
      }
    }
  end

  before do
    guest_user
  end

  describe "ゲストアカウントを表示した時" do
    it "戦績が表示されない事" do
      sign_in guest_user
      visit user_path(guest_user.id)
      expect(page).to have_content "ゲストアカウントでは戦績は表示できません。"
    end
  end

  describe "ユーザー詳細ページ" do
    context "ゲームアカウントが存在する時" do
      before do
        game_account_info
        allow(TrackerApiService).to receive(:fetch_trn_player_stats).and_return(tracker_api_service)
        visit user_path(user.id)
      end

      context "総合戦績" do
        it "レベルが表示される事" do
          within ".overall-record-area" do
            expect(page).to have_selector(".overall-stat .name", text: "Level")
            expect(page).to have_selector(".overall-stat .value", text: "1,557")
            expect(page).to have_selector(".overall-stat .rank", text: "25,233 - Top0.7%")
          end
        end

        it "キル数が表示される事" do
          within ".overall-record-area" do
            expect(page).to have_selector(".overall-stat .name", text: "Kills")
            expect(page).to have_selector(".overall-stat .value", text: "45,350")
            expect(page).to have_selector(".overall-stat .rank", text: "3,659 - Top0.1%")
          end
        end

        it "ダメージ数が表示される事" do
          within ".overall-record-area" do
            expect(page).to have_selector(".overall-stat .name", text: "Damage")
            expect(page).to have_selector(".overall-stat .value", text: "12,892,834")
            expect(page).to have_selector(".overall-stat .rank", text: "2,190 - Top0.1%")
          end
        end

        it "試合数が表示される事" do
          within ".overall-record-area" do
            expect(page).to have_selector(".overall-stat .name", text: "Matchesplayed")
            expect(page).to have_selector(".overall-stat .value", text: "8,916")
            expect(page).to have_selector(".overall-stat .rank", text: "--- - Top0.7%")
          end
        end

        it "勝利数が表示される事" do
          within ".overall-record-area" do
            expect(page).to have_selector(".overall-stat .name", text: "Wins")
            expect(page).to have_selector(".overall-stat .value", text: "1,599")
            expect(page).to have_selector(".overall-stat .rank", text: "4,285 - Top0.4%")
          end
        end

        it "キルリーダーとしてのキル数が表示される事" do
          within ".overall-record-area" do
            expect(page).to have_selector(".overall-stat .name", text: "Killsaskillleader")
            expect(page).to have_selector(".overall-stat .value", text: "3,383")
            expect(page).to have_selector(".overall-stat .rank", text: "--- - Top0.1%")
          end
        end

        it "シーズンキル数が表示される事" do
          within ".overall-record-area" do
            expect(page).to have_selector(".overall-stat .name", text: "Season10キル数")
            expect(page).to have_selector(".overall-stat .value", text: "4,122")
            expect(page).to have_selector(".overall-stat .rank", text: "--- - Top0.9%")
          end
        end

        it "シーズン勝利数が表示される事" do
          within ".overall-record-area" do
            expect(page).to have_selector(".overall-stat .name", text: "Season10勝利数")
            expect(page).to have_selector(".overall-stat .value", text: "---")
            expect(page).to have_selector(".overall-stat .rank", text: "--- - Top---")
          end
        end

        it "1試合での平均キル数が表示される事" do
          within ".overall-record-area" do
            expect(page).to have_selector(".overall-stat", text: "1試合での平均キル数")
            expect(page).to have_selector(".overall-stat .value", text: "5.08")
          end
        end

        it "勝率が表示される事" do
          within ".overall-record-area" do
            expect(page).to have_selector(".overall-stat .name", text: "勝率")
            expect(page).to have_selector(".overall-stat .value", text: "17.9%")
          end
        end

        it "現在のランクが表示される事" do
          within ".overall-record-area" do
            expect(page).to have_selector(".overall-stat .name", text: "現在のランク")
            expect(page).to have_selector(".overall-stat .value img, img[src$='master.png']")
            expect(page).to have_selector(".overall-stat .value", text: "Master")
            expect(page).to have_selector(".overall-stat .rank", text: "1,008 - Top0.2%")
          end
        end
      end

      context "レジェンドステータス" do
        it "取得したレジェンドの数だけカードが表示される事" do
          within ".trn-legend-stats-area" do
            expect(page.all(".legend-stats-card").count).to eq 2
          end
        end

        it "アイコンが表示されている事" do
          within ".trn-legend-stats-area" do
            expect(page).to have_selector(".legend-icon img, img[src$='Wraith_icon.jpg']")
          end
        end

        it "レジェンド名が表示されている事" do
          within ".trn-legend-stats-area" do
            expect(page).to have_selector(".legend-name", text: "Wraith")
          end
        end

        it "キル数が表示されている事" do
          within ".trn-legend-stats-area" do
            expect(page).to have_selector(".legend-stat .name", text: "Kills")
            expect(page).to have_selector(".legend-stat .value", text: "23,996")
            expect(page).to have_selector(".legend-stat .rank", text: "2,433 - Top1.0%")
          end
        end

        it "ダメージ数が表示されている事" do
          within ".trn-legend-stats-area" do
            expect(page).to have_selector(".legend-stat .name", text: "Damage")
            expect(page).to have_selector(".legend-stat .value", text: "7,025,561")
            expect(page).to have_selector(".legend-stat .rank", text: "2,000 - Top0.0%")
          end
        end

        it "勝利数が表示されている事" do
          within ".trn-legend-stats-area" do
            expect(page).to have_selector(".legend-stat .name", text: "Wins")
            expect(page).to have_selector(".legend-stat .value", text: "894")
            expect(page).to have_selector(".legend-stat .rank", text: "--- - Top1.0%")
          end
        end

        it "試合数が表示されている事" do
          within ".trn-legend-stats-area" do
            expect(page).to have_selector(".legend-stat .name", text: "Matchesplayed")
            expect(page).to have_selector(".legend-stat .value", text: "7,751")
            expect(page).to have_selector(".legend-stat .rank", text: "--- - Top0.5%")
          end
        end

        it "キルリーダーとしてのキル数が表示されている事" do
          within ".trn-legend-stats-area" do
            expect(page).to have_selector(".legend-stat .name", text: "Killsaskillleader")
            expect(page).to have_selector(".legend-stat .value", text: "965")
            expect(page).to have_selector(".legend-stat .rank", text: "--- - Top8.1%")
          end
        end
      end
    end

    context "ゲームアカウントが存在しない時" do
      it "戦績が取得できない事" do
        no_game_account_info
        visit user_path(user.id)
        expect(page).to have_selector(".trn-failed-stats-container h2", text: "戦績を取得できませんでした")
      end
    end

    context "APIリクエスト数が上限に達した時" do
      it "戦績が取得できない事" do
        game_account_info
        allow(TrackerApiService).to receive(:fetch_trn_player_stats).and_return("Apilimit")
        visit user_path(user.id)
        expect(page).to have_content "APIのリクエス数が上限に達しました。"
      end
    end
  end
end
