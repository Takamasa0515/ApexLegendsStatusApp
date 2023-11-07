require 'rails_helper'

RSpec.describe "Breadcrumbs", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:guest_user) { FactoryBot.create(:guest_user) }
  let(:game_account_info) { FactoryBot.create(:game_account_info, user:) }

  before do
    guest_user
    user
  end

  describe "新規登録画面に遷移した時" do
    it "Home>新規登録と表示される事" do
      visit new_user_registration_path
      within(".breadcrumbs") do
        expect(page).to have_content "Home"
        expect(page).to have_content "新規登録"
      end
    end
  end

  describe "ログイン画面に遷移した時" do
    it "Home>ログインと表示される事" do
      visit new_user_session_path
      within(".breadcrumbs") do
        expect(page).to have_content "Home"
        expect(page).to have_content "ログイン"
      end
    end
  end

  describe "ユーザー一覧画面に遷移した時" do
    it "Home>ユーザー一覧と表示される事" do
      visit users_path
      within(".breadcrumbs") do
        expect(page).to have_content "Home"
        expect(page).to have_content "ユーザー一覧"
      end
    end
  end

  describe "パスワード再設定メール送信ページに遷移した時" do
    it "Home>ログイン>パスワード再設定メール送信と表示される事" do
      visit new_user_password_path
      within(".breadcrumbs") do
        expect(page).to have_content "Home"
        expect(page).to have_content "ログイン"
        expect(page).to have_content "パスワード再設定メール送信"
      end
    end
  end

  describe "パスワード再設定ページに遷移した時" do
    it "Home>パスワード再設定と表示される事" do
      @token = Devise.friendly_token
      user.reset_password_token = Devise.token_generator.digest(self, :reset_password_token, @token)
      user.reset_password_sent_at = Time.now
      user.save!
      visit "#{edit_user_password_path}?reset_password_token=#{@token}"
      within(".breadcrumbs") do
        expect(page).to have_content "Home"
        expect(page).to have_content "パスワード再設定"
      end
    end
  end

  describe "ユーザー検索画面に遷移した時" do
    it "Home>ユーザー検索と表示される事" do
      visit search_users_path
      within(".breadcrumbs") do
        expect(page).to have_content "Home"
        expect(page).to have_content "ユーザー検索"
      end
    end
  end

  describe "ユーザー詳細画面に遷移した時" do
    context "マイページの時" do
      it "Home>ユーザー一覧>マイページと表示される事" do
        sign_in user
        visit user_path(user)
        within(".breadcrumbs") do
          expect(page).to have_content "Home"
          expect(page).to have_content "ユーザー一覧"
          expect(page).to have_content "マイページ"
        end
      end
    end
    context "他のユーザー詳細ページの時" do
      it "Home>ユーザー一覧>ユーザー名と表示される事" do
        visit user_path(user)
        within(".breadcrumbs") do
          expect(page).to have_content "Home"
          expect(page).to have_content "ユーザー一覧"
          expect(page).to have_content user.name
        end
      end
    end
  end

  describe "アカウント編集画面に遷移した時" do
    it "Home>ユーザー一覧>マイページ>アカウント編集と表示される事" do
      sign_in user
      visit edit_user_registration_path(user)
      within(".breadcrumbs") do
        expect(page).to have_content "Home"
        expect(page).to have_content "ユーザー一覧"
        expect(page).to have_content "マイページ"
        expect(page).to have_content "アカウント編集"
      end
    end
  end

  describe "ゲームアカウント登録・編集画面に遷移した時" do
    it "Home>ユーザー一覧>マイページ>ゲームアカウント登録・編集と表示される事" do
      sign_in user
      visit edit_game_account_info_path(user)
      within(".breadcrumbs") do
        expect(page).to have_content "Home"
        expect(page).to have_content "ユーザー一覧"
        expect(page).to have_content "マイページ"
        expect(page).to have_content "ゲームアカウント登録・編集"
      end
    end
  end

  describe "試合履歴画面に遷移した時" do
    context "ログインユーザーの時" do
      it "Home>ユーザー一覧>マイページ>試合履歴と表示される事" do
        sign_in user
        visit user_tracker_match_records_path(user)
        within(".breadcrumbs") do
          expect(page).to have_content "Home"
          expect(page).to have_content "ユーザー一覧"
          expect(page).to have_content "マイページ"
          expect(page).to have_content "試合履歴"
        end
      end
    end

    context "他のユーザーの時" do
      it "Home>ユーザー一覧>ユーザー名>試合履歴と表示される事" do
        visit user_tracker_match_records_path(user)
        within(".breadcrumbs") do
          expect(page).to have_content "Home"
          expect(page).to have_content "ユーザー一覧"
          expect(page).to have_content user.name
          expect(page).to have_content "試合履歴"
        end
      end
    end
  end

  describe "お問い合わせ画面に遷移した時" do
    it "Home>お問い合わせと表示される事" do
      visit new_contact_path
      within(".breadcrumbs") do
        expect(page).to have_content "Home"
        expect(page).to have_content "お問い合わせ"
      end
    end
  end

  describe "お問い合わせ確認画面に遷移した時" do
    it "Home>お問い合わせ>確認画面と表示される事" do
      visit new_contact_path
      fill_in "お名前", with: "テストユーザー"
      fill_in "お問い合わせ内容", with: "テスト"
      click_button "入力内容確認"
      within(".breadcrumbs") do
        expect(page).to have_content "Home"
        expect(page).to have_content "お問い合わせ"
        expect(page).to have_content "確認画面"
      end
    end
  end

  describe "お問い合わせ送信完了画面に遷移した時" do
    it "Home>お問い合わせ>送信完了と表示される事" do
      visit new_contact_path
      fill_in "お名前", with: "テストユーザー"
      fill_in "お問い合わせ内容", with: "テスト"
      click_button "入力内容確認"
      click_button "送信"
      within(".breadcrumbs") do
        expect(page).to have_content "Home"
        expect(page).to have_content "お問い合わせ"
        expect(page).to have_content "送信完了"
      end
    end
  end
end
