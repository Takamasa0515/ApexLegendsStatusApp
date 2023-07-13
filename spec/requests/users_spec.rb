require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:game_account_info) { FactoryBot.create(:game_account_info, user:) }

  describe 'GET /users/:id' do
    context "ゲームアカウントが存在するとき" do
      before do
        sign_in user
        game_account_info
        get user_path(user.id)
      end

      it "getメソッドで通信し、ステータスコード200を返すこと" do
        expect(response).to have_http_status(200)
      end

      it "ユーザー名が表示されること" do
        expect(response.body).to include(user.name)
      end

      it "プラットフォームが表示されること" do
        expect(response.body).to include(game_account_info.platform)
      end

      it "ゲームIDが表示されること" do
        expect(response.body).to include(game_account_info.gameid)
      end
    end

    context "ゲームアカウントが存在しないとき" do
      before do
        sign_in user
        get user_path(user.id)
      end

      it "戦績を取得できませんでしたと表示されること" do
        expect(response.body).to include("戦績を取得できませんでした")
      end
    end
  end
end
