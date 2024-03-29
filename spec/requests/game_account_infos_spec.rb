require 'rails_helper'

RSpec.describe "GameAccountInfos", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:guest_user) { FactoryBot.create(:guest_user) }
  let(:game_account_info) { FactoryBot.build(:game_account_info, user:) }
  let(:tracker_match_record) { FactoryBot.create(:tracker_match_record, user:) }

  describe "GET/edit_game_account_info" do
    before do
      guest_user
      user
    end
    context "ユーザーアカウントでログインしている時" do
      before do
        sign_in user
        get edit_game_account_info_path(user)
      end

      it "getメソッドで通信し、ステータスコード200を返すこと" do
        expect(response).to have_http_status(200)
      end

      context "新規にゲームアカウントを登録する時" do
        it "プラットフォームのプルダウンが選択して下さいとなる事" do
          expect(response.body).to include("選択して下さい")
        end

        it "ゲームIDが表示されない事" do
          expect(response.body).not_to include(game_account_info.gameid)
        end
      end

      context "すでにゲームアカウントが登録されている時" do
        before do
          game_account_info.save
          get edit_game_account_info_path(user)
        end

        it "プラットフォームが取得できている事" do
          expect(response.body).to include(user.game_account_info.platform)
        end

        it "ゲームIDが取得できている事" do
          expect(response.body).to include(user.game_account_info.gameid)
        end
      end
    end

    context "ゲストアカウントでログインしている時" do
      before do
        sign_in guest_user
        get edit_game_account_info_path(guest_user)
      end

      it "マイページにリダイレクトされる事" do
        expect(response).to redirect_to(user_path(guest_user))
      end
    end
  end

  describe "PATCH/game_account_info" do
    before do
      guest_user
      user
      user.last_accessed_at_match_record = Time.zone.today
      sign_in user
    end

    context "ゲームアカウントが変更された時" do
      before do
        tracker_match_record
        patch game_account_info_path(user), params: { game_account_info: { platform: "origin", gameid: "Test" } }
      end

      it "試合履歴が削除される事" do
        expect(user.tracker_match_records).to be_empty
      end

      it "ユーザーのlast_accessed_at_match_recordがnilになる事" do
        user.reload
        expect(user.last_accessed_at_match_record).to be_nil
      end

      it "マイページにリダイレクトされる事" do
        expect(response).to redirect_to(user_path(user))
      end
    end
  end
end
