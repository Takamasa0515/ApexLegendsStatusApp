require 'rails_helper'

RSpec.describe TrackerMatchRecord, type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:guest_user) { FactoryBot.create(:guest_user) }
  let(:steam_game_account_info) { FactoryBot.create(:steam_game_account_info, user:) }
  let(:no_game_account_info) { FactoryBot.create(:no_game_account_info, user:) }
  let(:api_tracker_match_record) do
    {
      "data" => {
        "items" => [
          {
            "metadata" => {
              "endDate" => { "value" => Time.zone.today.beginning_of_month.to_s }
            },
            "matches" => [
              {
                "metadata" => {
                  "endDate" => { "value" => Time.zone.today.beginning_of_month.to_s },
                  "character" => { "displayValue" => "Wraith" }
                },
                "stats" => {
                  "kills" => { "value" => 10 },
                  "damage" => { "value" => 1800 },
                  "wins" => { "value" => 1 }
                }
              }
            ],
            "stats" => {
              "kills" => { "value" => 10 },
              "damage" => { "value" => 1800 },
              "wins" => { "value" => 1 }
            }
          }
        ]
      }
    }
  end

  describe "試合履歴ページに遷移した時" do
    before do
      guest_user
      user
      sign_in user
    end

    describe "ゲームアカウントが存在する時" do
      before do
        steam_game_account_info
      end

      it "カレンダーが表示される事" do
        allow(TrackerMatchRecord).to receive(:fetch_trn_match_history).and_return(api_tracker_match_record)
        visit user_tracker_match_records_path(user.id)
        expect(page).to have_css ".simple-calendar"
      end

      describe "試合履歴がある場合" do
        before do
          allow(TrackerMatchRecord).to receive(:fetch_trn_match_history).and_return(api_tracker_match_record)
          visit user_tracker_match_records_path(user.id)
        end

        context "今月のカレンダーを表示した時" do
          it "先月のカレンダーに遷移できる事" do
            click_link "先月"
            expect(page).to have_content "#{Time.zone.today.last_month.month}月"
          end

          it "先月から今月に戻れる事" do
            click_link "先月"
            click_link "来月"
            expect(page).to have_content "#{Date.current.month}月"
          end

          it "カレンダーにキル数が表示されている事" do
            expect(page).to have_selector(".day button p", text: "10kill")
          end

          it "日付をクリックで詳細を表示と表示される事" do
            expect(page).to have_content "日付をクリックで詳細を表示"
          end

          context "試合履歴がある日付をクリックした時" do
            before do
              click_button "10kills"
            end

            it "日時の詳細が表示される事" do
              within ".legend-stats-title" do
                expect(page).to have_content Time.zone.today.beginning_of_month.to_s
              end
            end

            it "レジェンドが表示される事" do
              within ".legend-stats-card" do
                expect(page).to have_content "レイス"
              end
            end

            it "レジェンドの画像が表示される事" do
              within ".legend-stats-card" do
                expect(page).to have_selector(".legend-icon img, img[src$='Wraith_icon.jpg']")
              end
            end

            it "キル数が表示される事" do
              within ".legend-stats-card" do
                expect(page).to have_content "10"
              end
            end

            it "ダメージ数が表示される事" do
              within ".legend-stats-card" do
                expect(page).to have_content "1,800"
              end
            end

            it "勝利数が表示される事" do
              within ".legend-stats-card" do
                expect(page).to have_content "1"
              end
            end
          end

          context "試合履歴がない日付をクリックした時" do
            before do
              click_button("15", match: :first)
            end

            it "日時の詳細が表示される事" do
              within ".legend-stats-title" do
                expect(page).to have_content (Time.zone.today.beginning_of_month + 14).to_s
              end
            end

            it "日付をクリックで詳細を表示と表示される事" do
              within ".no-match-result-card" do
                expect(page).to have_content "日付をクリックで詳細を表示"
              end
            end
          end
        end
      end
    end

    describe "ゲームアカウントが存在しない時" do
      it "カレンダーが表示されない事" do
        no_game_account_info
        allow(TrackerMatchRecord).to receive(:fetch_trn_match_history).and_return("No account")
        visit user_tracker_match_records_path(user.id)
        expect(page).not_to have_css ".simple-calendar"
        expect(page).to have_content "戦績を取得できませんでした"
      end
    end

    describe "APIリクエスト数が上限に達した時" do
      it "試合履歴が表示できない事" do
        steam_game_account_info
        allow(TrackerMatchRecord).to receive(:fetch_trn_match_history).and_return("Apilimit")
        visit user_tracker_match_records_path(user.id)
        expect(page).to have_content "APIのリクエス数が上限に達しました"
      end
    end
  end
end
