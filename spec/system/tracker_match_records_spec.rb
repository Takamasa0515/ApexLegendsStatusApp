require 'rails_helper'

RSpec.describe TrackerMatchRecord, type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:game_account_info) { FactoryBot.create(:game_account_info, user: user) }
  let(:tracker_match_record) { FactoryBot.create(:tracker_match_record, user: user)}

  describe "試合履歴ページに遷移した時" do
    before do
      sign_in user
    end

    it "カレンダーが表示される事" do
      visit user_tracker_match_records_path(user.id)
      expect(page).to have_css ".simple-calendar"
    end

    describe "試合履歴がある場合" do
      before do
        tracker_match_record
        visit user_tracker_match_records_path(user.id)
      end

      context "今月のカレンダーを表示した時" do
        it "先月のカレンダーに遷移できる事" do
          click_link "先月"
          expect(page).to have_content "#{Date.today.last_month.month}月"
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
            click_button "10kill"
          end

          it "日時の詳細が表示される事" do
            expect(page).to have_content tracker_match_record.match_date.to_s
          end

          it "レジェンドが表示される事" do
            expect(page).to have_content tracker_match_record.legend
          end

          it "レジェンドの画像が表示される事" do
            expect(page).to have_selector(".legend-icon img, img[src$='Wraith_icon.jpg']")
          end

          it "キル数が表示される事" do
            expect(page).to have_content tracker_match_record.kills
          end

          it "ダメージ数が表示される事" do
            expect(page).to have_content tracker_match_record.damages.to_fs(:delimited)
          end

          it "勝利数が表示される事" do
            expect(page).to have_content tracker_match_record.wins
          end
        end

        context "試合履歴がない日付をクリックした時" do
          before do
            click_button("2", match: :first)
          end

          it "日時の詳細が表示される事" do
            expect(page).to have_content (Date.today.beginning_of_month + 1).to_s
          end

          it "日付をクリックで詳細を表示と表示される事" do
            expect(page).to have_content "日付をクリックで詳細を表示"
          end
        end
      end
    end
  end
end
