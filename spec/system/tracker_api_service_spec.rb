require 'rails_helper'

RSpec.describe TrackerApiService, type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:guest_user) { FactoryBot.create(:guest_user) }
  let(:game_account_info) { FactoryBot.create(:game_account_info, user: user) }
  let(:no_game_account_info) { FactoryBot.create(:no_game_account_info, user: user) }

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
      it "総合戦績が表示される事" do
        game_account_info
        visit user_path(user.id)
        expect(page).to have_selector(".overall-title p, 総合戦績")
        expect(page).to have_selector(".legend-stats-title h2, レジェンドステータス")
      end
    end

    context "ゲームアカウントが存在しない時" do
      it "戦績が取得できない事" do
        no_game_account_info
        visit user_path(user.id)
        expect(page).to have_selector(".trn-failed-stats-container h2, 戦績を取得できませんでした")
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
