require 'rails_helper'

RSpec.describe TrackerApiService, type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:game_account_info) { FactoryBot.create(:game_account_info, user: user) }
  let(:no_game_account_info) { FactoryBot.create(:no_game_account_info, user: user) }

  describe "API通信を行う時" do
    context "ゲームアカウントが存在する時" do
      it "アカウント情報が返ってくること" do
        result = TrackerApiService.fetch_trn_player_stats(game_account_info)
        expect(result).to include("data")
      end
    end

    context "ゲームアカウントが見つからない時" do
      it "No accountを返す事" do
        result = TrackerApiService.fetch_trn_player_stats(no_game_account_info)
        expect(result).to eq "No account"
      end
    end

    context "APIリクエスト数の上限に達した時" do
      it "Apilimitを返す事" do
        allow(TrackerApiService).to receive(:fetch_trn_player_stats).and_return("Apilimit")
        result = TrackerApiService.fetch_trn_player_stats(game_account_info)
        expect(result).to eq "Apilimit"
      end
    end
  end
end
