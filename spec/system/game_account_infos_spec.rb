require 'rails_helper'

RSpec.describe Users, type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:registered_user) { FactoryBot.create(:registered_user) }
  let(:guest_user) { FactoryBot.create(:guest_user) }
  let(:game_account_info) { FactoryBot.create(:game_account_info, user: user) }

  before do
    guest_user
  end

  describe "ゲストユーザーでログインしている時" do
    it "ゲームアカウントを登録できない事" do
      sign_in guest_user
      user = guest_user
      visit user_path(user.id)
      click_link "ゲームアカウントを登録・編集する"
      expect(page).to have_content "ゲストアカウントにはゲームアカウントを登録できません。"
      expect(current_path).to eq user_path(user.id)
    end
  end

  describe "ユーザーでログインしている時" do
    before do
      sign_in user
    end

    context "マイページに遷移した時" do
      it "ゲームアカウント登録・編集ボタンが表示されている事" do
        visit user_path(user.id)
        expect(page).to have_selector("a.btn-dark, ゲームアカウントを登録・編集する")
      end
    end

    context "他ユーザーのページに遷移した時" do
      it "ゲームアカウント登録・編集ボタンが表示されない事" do
        visit user_path(registered_user.id)
        expect(page).not_to have_selector("a.btn-dark, ゲームアカウントを登録・編集する")
      end
    end

    context "ゲームアカウント登録・編集ページに遷移した時" do
      context "ゲームアカウントが登録されていない時" do
        it "プラットフォームが選択して下さいになっている事" do
          visit edit_game_account_info_path(user.id)
          expect(page).to have_select("プラットフォーム", selected: "選択して下さい")
        end

        it "ゲームIDが空白である事" do
          visit edit_game_account_info_path(user.id)
          expect(find_field("ゲームID").value).to be_blank
        end
      end

      context "ゲームアカウントが登録されてい時" do
        before do
          game_account_info
        end

        it "プラットフォームが指定されている事" do
          visit edit_game_account_info_path(user.id)
          expect(page).to have_select("プラットフォーム", selected: user.game_account_info.platform.capitalize)
        end

        it "ゲームIDが入力されている事" do
          visit edit_game_account_info_path(user.id)
          expect(page).to have_field("ゲームID", with: user.game_account_info.gameid)
        end
      end

      context "ゲームアカウントを登録する時" do
        context "フォームの入力値が正常の時" do
          it "登録が成功する事" do
            visit edit_game_account_info_path(user.id)
            select "Steam", from: "プラットフォーム"
            fill_in "ゲームID" , with: "TestID"
            click_button "登録する"
            expect(page).to have_content "ゲームアカウント情報を更新しました"
            expect(page).to have_selector(".game-account-info span, TestID")
            expect(page).to have_selector(".platform-icon, img[src$='steam_icon.png']")
            expect(current_path).to eq user_path(user.id)
          end
        end

        context "プラットフォームが選択されていない時" do
          it "登録が失敗する事" do
            visit edit_game_account_info_path(user.id)
            fill_in "ゲームID" , with: "TestID"
            click_button "登録する"
            expect(page).to have_content "プラットフォームを入力してください"
            expect(current_path).to eq edit_game_account_info_path(user.id)
          end
        end

        context "ゲームIDが未入力の時" do
          it "登録が失敗する事" do
            visit edit_game_account_info_path(user.id)
            select "Origin", from: "プラットフォーム"
            click_button "登録する"
            expect(page).to have_content "ゲームIDを入力してください"
            expect(current_path).to eq edit_game_account_info_path(user.id)
          end
        end
      end

      context "ゲームアカウントを更新する時" do
        before do
          game_account_info
        end

        context "フォームの入力値が正常の時" do
          it "更新が成功する事" do
            visit edit_game_account_info_path(user.id)
            select "Steam", from: "プラットフォーム"
            fill_in "ゲームID" , with: "TestID"
            click_button "登録する"
            expect(page).to have_content "ゲームアカウント情報を更新しました"
            expect(page).to have_selector(".game-account-info span, TestID")
            expect(page).to have_selector(".platform-icon, img[src$='steam_icon.png']")
            expect(current_path).to eq user_path(user.id)
          end
        end

        context "プラットフォームが選択して下さいになっている時" do
          it "登録が失敗する事" do
            visit edit_game_account_info_path(user.id)
            select "選択して下さい", from: "プラットフォーム"
            click_button "登録する"
            expect(page).to have_content "プラットフォームを入力してください"
            expect(current_path).to eq edit_game_account_info_path(user.id)
          end
        end

        context "ゲームIDが未入力の時" do
          it "登録が失敗する事" do
            visit edit_game_account_info_path(user.id)
            fill_in "ゲームID" , with: ""
            click_button "登録する"
            expect(page).to have_content "ゲームIDを入力してください"
            expect(current_path).to eq edit_game_account_info_path(user.id)
          end
        end
      end
    end
  end
end