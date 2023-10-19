require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:guest_user) { FactoryBot.create(:guest_user) }
  let(:game_account_info) { FactoryBot.create(:game_account_info, user: user) }
  let(:no_game_account_info) { FactoryBot.create(:no_game_account_info, user: user) }

  describe "GET/users" do
    before do
      guest_user
      user
      game_account_info
      get users_path
    end

    it "getメソッドで通信し、ステータスコード200を返すこと" do
      expect(response).to have_http_status(200)
    end

    it "全てのユーザーが表示されている事" do
      expect(response.body).to include(user.name, guest_user.name)
    end

    it "プロフィールが表示されている事" do
      expect(response.body).to include(user.self_introduction, guest_user.self_introduction)
    end

    it "ゲームIDが表示されている事" do
      expect(response.body).to include(user.game_account_info.gameid)
    end
  end

  describe "GET/users/:id" do
    before do
      guest_user
      user
    end

    context "ゲームアカウントが存在する時" do
      before do
        sign_in user
        game_account_info
        allow(TrackerApiService).to receive(:fetch_trn_player_stats).and_return("Apilimit")
        get user_path(user.id)
      end

      it "getメソッドで通信し、ステータスコード200を返すこと" do
        expect(response).to have_http_status(200)
      end

      it "ユーザー名が表示されること" do
        expect(response.body).to include(user.name)
      end

      it "プロフィールが表示されること" do
        expect(response.body).to include(user.self_introduction)
      end

      it "ゲームIDが表示されること" do
        expect(response.body).to include(user.game_account_info.gameid)
      end
    end

    context "ゲームアカウントを登録していない時" do
      before do
        sign_in user
        allow(TrackerApiService).to receive(:fetch_trn_player_stats).and_return("No account")
        get user_path(user.id)
      end

      it "ゲームIDが表示されない事" do
        expect(response.body).not_to include(game_account_info.gameid)
      end

      it "戦績を取得できませんでした、と表示されること" do
        expect(response.body).to include("戦績を取得できませんでした")
      end
    end

    context "登録したゲームアカウントが存在しない時" do
      before do
        sign_in user
        no_game_account_info
        allow(TrackerApiService).to receive(:fetch_trn_player_stats).and_return("No account")
        get user_path(user.id)
      end

      it "ゲームIDが表示されること" do
        expect(response.body).to include(user.game_account_info.gameid)
      end

      it "戦績を取得できませんでした、と表示されること" do
        expect(response.body).to include("戦績を取得できませんでした")
      end
    end

    context "ゲストアカウントでログインした時" do
      before do
        sign_in guest_user
        get user_path(guest_user.id)
      end

      it "ユーザー名がゲストアカウントと表示される事" do
        expect(response.body).to include(guest_user.name)
      end

      it "ゲストアカウント用のプロフィールが表示されること" do
        expect(response.body).to include(guest_user.self_introduction)
      end

      it "ゲストアカウントでは戦績は表示できません、と表示される事" do
        expect(response.body).to include("ゲストアカウントでは戦績は表示できません")
      end
    end
  end

  describe "DELETE/user" do
    before do
      guest_user
      user
      delete user_path(user)
    end

    it "ユーザーが削除される事" do
      expect(User.all).not_to include(user)
    end
  end
end
