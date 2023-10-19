require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:game_account_info) { FactoryBot.create(:game_account_info, user: user) }
  let(:no_game_account_info) { FactoryBot.create(:no_game_account_info, user: user) }

  describe "API通信を行う時" do
    context "ゲームアカウントが存在する時" do
      it "アカウント情報が返ってくること" do
        result = TrackerMatchRecord.fetch_trn_match_history(game_account_info)
        expect(result).to include("data")
      end
    end

    context "ゲームアカウントが見つからない時" do
      it "No accountを返す事" do
        result = TrackerMatchRecord.fetch_trn_match_history(no_game_account_info)
        expect(result).to eq "No account"
      end
    end

    context "APIリクエスト数の上限に達した時" do
      it "Apilimitを返す事" do
        allow(TrackerMatchRecord).to receive(:fetch_trn_match_history).and_return("Apilimit")
        result = TrackerMatchRecord.fetch_trn_match_history(game_account_info)
        expect(result).to eq "Apilimit"
      end
    end
  end

  describe "GET/user_tracker_match_records" do
    before do
      get user_tracker_match_records_path(user)
    end

    it "getメソッドで通信し、ステータスコード200を返すこと" do
      expect(response).to have_http_status(200)
    end

    it "今月のカレンダーが表示される事" do
      expect(response.body).to include("#{Date.today.month.to_s}月 #{Date.today.year.to_s}")
    end
  end

  describe "GET/user_tracker_show_records" do
    before do
      get user_tracker_show_records_path(user)
    end

    it "getメソッドで通信し、ステータスコード200を返すこと" do
      expect(response).to have_http_status(200)
    end
  end
end
