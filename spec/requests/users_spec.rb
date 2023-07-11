require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:game_account_info) { FactoryBot.create(:game_account_info, user: user) }

  describe 'GET /users/:id' do
    before do
      sign_in user
      game_account_info
      get user_path(user.id)
    end

    context "ゲームアカウントが存在するとき" do
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
  end
end
