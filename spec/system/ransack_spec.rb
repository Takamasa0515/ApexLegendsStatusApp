require 'rails_helper'

RSpec.describe "ransack", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:user2) { FactoryBot.create(:user2) }
  let(:guest_user) { FactoryBot.create(:guest_user) }
  let(:game_account_info) { FactoryBot.create(:game_account_info, user:) }
  let(:steam_game_account_info) { FactoryBot.create(:steam_game_account_info, user: user2) }

  before do
    guest_user
    user
    user2
    game_account_info
    steam_game_account_info
  end

  describe "ナビバー検索フォーム" do
    before do
      visit root_path
    end

    describe "ユーザー名を入力した時" do
      context "入力したユーザー名と一致するユーザーが存在する時" do
        it "ユーザーが表示される事" do
          fill_in "q[name_or_game_account_info_platform_or_game_account_info_gameid_cont]", with: "ゲストアカウント"
          click_button "検索"
          expect(page).to have_selector(".result-user-info p, ゲストアカウント")
          expect(page).to have_selector(".header-container p , 検索結果：1")
          expect(current_path).to eq search_users_path
        end
      end

      context "入力したユーザー名を含むユーザーが存在する時" do
        it "該当する全てのユーザーが表示される事" do
          fill_in "q[name_or_game_account_info_platform_or_game_account_info_gameid_cont]", with: "user"
          click_button "検索"
          expect(page).to have_selector(".result-user-info p, user")
          expect(page).to have_selector(".result-user-info p, user2")
          expect(page).to have_selector(".header-container p , 検索結果：2")
          expect(current_path).to eq search_users_path
        end
      end

      context "入力したユーザー名を含むユーザーが存在しない時" do
        it "ユーザーが表示されない事" do
          fill_in "q[name_or_game_account_info_platform_or_game_account_info_gameid_cont]", with: "no_user"
          click_button "検索"
          expect(page).to have_content "該当するユーザーは見つかりませんでした。別の条件で検索してみてください。"
          expect(current_path).to eq search_users_path
        end
      end
    end

    describe "プラットフォームを入力した時" do
      context "該当するユーザーが存在する時" do
        it "ユーザーが表示される事" do
          fill_in "q[name_or_game_account_info_platform_or_game_account_info_gameid_cont]", with: "origin"
          click_button "検索"
          expect(page).to have_selector(".result-user-info p, user")
          expect(page).to have_selector(".header-container p , 検索結果：1")
          expect(current_path).to eq search_users_path
        end
      end

      context "該当するユーザーが存在しない時" do
        it "ユーザーが表示されない事" do
          fill_in "q[name_or_game_account_info_platform_or_game_account_info_gameid_cont]", with: "psn"
          click_button "検索"
          expect(page).to have_content "該当するユーザーは見つかりませんでした。別の条件で検索してみてください。"
          expect(current_path).to eq search_users_path
        end
      end
    end

    describe "ゲームIDを入力した時" do
      context "該当するユーザーが存在する時" do
        it "ユーザーが表示される事" do
          fill_in "q[name_or_game_account_info_platform_or_game_account_info_gameid_cont]", with: "Twitch_Ne1u"
          click_button "検索"
          expect(page).to have_selector(".result-user-info p, user")
          expect(page).to have_selector(".header-container p , 検索結果：1")
          expect(current_path).to eq search_users_path
        end
      end

      context "該当するユーザーが存在しない時" do
        it "ユーザーが表示されない事" do
          fill_in "q[name_or_game_account_info_platform_or_game_account_info_gameid_cont]", with: "no_account"
          click_button "検索"
          expect(page).to have_content "該当するユーザーは見つかりませんでした。別の条件で検索してみてください。"
          expect(current_path).to eq search_users_path
        end
      end
    end

    describe "特定の文字列が含まれるユーザーを曖昧検索をした時" do
      context "該当するユーザーが存在する時" do
        it "ユーザーが表示される事" do
          fill_in "q[name_or_game_account_info_platform_or_game_account_info_gameid_cont]", with: "2"
          click_button "検索"
          expect(page).to have_selector(".result-user-info p, user2")
          expect(page).to have_selector(".header-container p , 検索結果：1")
          expect(current_path).to eq search_users_path
        end
      end

      context "該当するユーザーが存在しない時" do
        it "ユーザーが表示されない事" do
          fill_in "q[name_or_game_account_info_platform_or_game_account_info_gameid_cont]", with: "no"
          click_button "検索"
          expect(page).to have_content "該当するユーザーは見つかりませんでした。別の条件で検索してみてください。"
          expect(current_path).to eq search_users_path
        end
      end
    end
  end

  describe "users検索フォーム" do
    before do
      visit search_users_path
    end

    it "全てのユーザーが表示されている事" do
      expect(page).to have_selector(".result-user-info p, ゲストアカウント")
      expect(page).to have_selector(".result-user-info p, user")
      expect(page).to have_selector(".result-user-info p, user2")
      expect(page).to have_selector(".header-container p , 検索結果：3")
      expect(current_path).to eq search_users_path
    end

    describe "ユーザー名を入力した時" do
      context "入力したユーザー名と一致するユーザーが存在する時" do
        it "ユーザーが表示される事" do
          fill_in "q[name_or_game_account_info_gameid_cont]", with: "ゲストアカウント"
          within(".main-field") do
            click_button "検索"
          end
          expect(page).to have_selector(".result-user-info p, ゲストアカウント")
          expect(page).to have_selector(".header-container p , 検索結果：1")
          expect(current_path).to eq search_users_path
        end
      end

      context "入力したユーザー名を含むユーザーが複数存在する時" do
        it "複数のユーザーが表示される事" do
          fill_in "q[name_or_game_account_info_gameid_cont]", with: "user"
          within(".main-field") do
            click_button "検索"
          end
          expect(page).to have_selector(".result-user-info p, user")
          expect(page).to have_selector(".result-user-info p, user2")
          expect(page).to have_selector(".header-container p , 検索結果：2")
          expect(current_path).to eq search_users_path
        end
      end

      context "入力したユーザー名を含むユーザーが存在しない時" do
        it "ユーザーが表示されない事" do
          fill_in "q[name_or_game_account_info_gameid_cont]", with: "no_user"
          within(".main-field") do
            click_button "検索"
          end
          expect(page).to have_content "該当するユーザーは見つかりませんでした。別の条件で検索してみてください。"
          expect(current_path).to eq search_users_path
        end
      end
    end

    describe "ゲームIDを入力した時" do
      context "入力したゲームIDと一致するユーザーが存在する時" do
        it "ユーザーが表示される事" do
          fill_in "q[name_or_game_account_info_gameid_cont]", with: "Twitch_Ne1u"
          within(".main-field") do
            click_button "検索"
          end
          expect(page).to have_selector(".result-user-info p, user")
          expect(page).to have_selector(".header-container p , 検索結果：1")
          expect(current_path).to eq search_users_path
        end
      end

      context "入力したゲームIDを含むユーザーが存在する時" do
        it "ユーザーが表示される事" do
          fill_in "q[name_or_game_account_info_gameid_cont]", with: "Twitch"
          within(".main-field") do
            click_button "検索"
          end
          expect(page).to have_selector(".result-user-info p, user")
          expect(page).to have_selector(".header-container p , 検索結果：1")
          expect(current_path).to eq search_users_path
        end
      end

      context "入力したゲームIDに該当するユーザーが存在しない時" do
        it "ユーザーが表示されない事" do
          fill_in "q[name_or_game_account_info_gameid_cont]", with: "no_account"
          within(".main-field") do
            click_button "検索"
          end
          expect(page).to have_content "該当するユーザーは見つかりませんでした。別の条件で検索してみてください。"
          expect(page).to have_selector(".header-container p , 検索結果：0")
          expect(current_path).to eq search_users_path
        end
      end
    end

    describe "プラットフォームを指定した時" do
      context "指定した条件に該当するユーザーが存在する時" do
        it "ユーザーが表示される事" do
          select "Origin", from: "プラットフォーム"
          within(".main-field") do
            click_button "検索"
          end
          expect(page).to have_selector(".result-user-info p, user")
          expect(page).to have_selector(".header-container p , 検索結果：1")
          expect(current_path).to eq search_users_path
        end
      end

      context "指定した条件に該当するユーザーが存在しない時" do
        it "ユーザーが表示されない事" do
          select "PlayStation", from: "プラットフォーム"
          within(".main-field") do
            click_button "検索"
          end
          expect(page).to have_content "該当するユーザーは見つかりませんでした。別の条件で検索してみてください。"
          expect(page).to have_selector(".header-container p , 検索結果：0")
          expect(current_path).to eq search_users_path
        end
      end
    end

    describe "現在のランクを指定した時" do
      context "指定した条件に該当するユーザーが存在する時" do
        it "ユーザーが表示される事" do
          check "マスター"
          within(".main-field") do
            click_button "検索"
          end
          expect(page).to have_selector(".result-user-info p, user")
          expect(page).to have_selector(".header-container p , 検索結果：1")
          expect(current_path).to eq search_users_path
        end
      end

      context "複数指定した条件に該当するユーザーが存在する時" do
        it "該当する全てのユーザーが表示される事" do
          check "マスター"
          check "プラチナ"
          within(".main-field") do
            click_button "検索"
          end
          expect(page).to have_selector(".result-user-info p, user")
          expect(page).to have_selector(".result-user-info p, user2")
          expect(page).to have_selector(".header-container p , 検索結果：2")
          expect(current_path).to eq search_users_path
        end
      end

      context "指定した条件に該当するユーザーが存在しない時" do
        it "ユーザーが表示されない事" do
          check "プレデター"
          within(".main-field") do
            click_button "検索"
          end
          expect(page).to have_content "該当するユーザーは見つかりませんでした。別の条件で検索してみてください。"
          expect(page).to have_selector(".header-container p , 検索結果：0")
          expect(current_path).to eq search_users_path
        end
      end
    end

    describe "複数の条件を指定した時" do
      context "指定した全ての条件に該当するユーザーが存在する時" do
        it "ユーザーが表示される事" do
          fill_in "q[name_or_game_account_info_gameid_cont]", with: "user"
          select "Origin", from: "プラットフォーム"
          check "マスター"
          within(".main-field") do
            click_button "検索"
          end
          expect(page).to have_selector(".result-user-info p, user")
          expect(page).to have_selector(".header-container p , 検索結果：1")
          expect(current_path).to eq search_users_path
        end
      end

      context "一部の条件が一致する時" do
        it "ユーザー名のみ一致する時、ユーザーが表示されない事" do
          fill_in "q[name_or_game_account_info_gameid_cont]", with: "user"
          select "PlayStation", from: "プラットフォーム"
          check "ゴールド"
          within(".main-field") do
            click_button "検索"
          end
          expect(page).to have_content "該当するユーザーは見つかりませんでした。別の条件で検索してみてください。"
          expect(page).to have_selector(".header-container p , 検索結果：0")
          expect(current_path).to eq search_users_path
        end

        it "プラットフォームのみ一致する時、ユーザーが表示されない事" do
          fill_in "q[name_or_game_account_info_gameid_cont]", with: "no_user"
          select "Origin", from: "プラットフォーム"
          check "ゴールド"
          within(".main-field") do
            click_button "検索"
          end
          expect(page).to have_content "該当するユーザーは見つかりませんでした。別の条件で検索してみてください。"
          expect(page).to have_selector(".header-container p , 検索結果：0")
          expect(current_path).to eq search_users_path
        end

        it "現在のランクのみ一致する時、ユーザーが表示されない事" do
          fill_in "q[name_or_game_account_info_gameid_cont]", with: "no_user"
          select "PlayStation", from: "プラットフォーム"
          check "マスター"
          within(".main-field") do
            click_button "検索"
          end
          expect(page).to have_content "該当するユーザーは見つかりませんでした。別の条件で検索してみてください。"
          expect(page).to have_selector(".header-container p , 検索結果：0")
          expect(current_path).to eq search_users_path
        end

        it "ユーザー名のみ一致しない時、ユーザーが表示されない事" do
          fill_in "q[name_or_game_account_info_gameid_cont]", with: "no_user"
          select "Origin", from: "プラットフォーム"
          check "マスター"
          within(".main-field") do
            click_button "検索"
          end
          expect(page).to have_content "該当するユーザーは見つかりませんでした。別の条件で検索してみてください。"
          expect(page).to have_selector(".header-container p , 検索結果：0")
          expect(current_path).to eq search_users_path
        end

        it "プラットフォームのみ一致しない時、ユーザーが表示されない事" do
          fill_in "q[name_or_game_account_info_gameid_cont]", with: "user"
          select "PlayStation", from: "プラットフォーム"
          check "マスター"
          within(".main-field") do
            click_button "検索"
          end
          expect(page).to have_content "該当するユーザーは見つかりませんでした。別の条件で検索してみてください。"
          expect(page).to have_selector(".header-container p , 検索結果：0")
          expect(current_path).to eq search_users_path
        end

        it "現在のランクのみ一致しない時、ユーザーが表示されない事" do
          fill_in "q[name_or_game_account_info_gameid_cont]", with: "user"
          select "Origin", from: "プラットフォーム"
          check "ゴールド"
          within(".main-field") do
            click_button "検索"
          end
          expect(page).to have_content "該当するユーザーは見つかりませんでした。別の条件で検索してみてください。"
          expect(page).to have_selector(".header-container p , 検索結果：0")
          expect(current_path).to eq search_users_path
        end
      end

      context "指定した全ての条件に該当するユーザーが存在しない時" do
        it "ユーザーが表示されない事" do
          fill_in "q[name_or_game_account_info_gameid_cont]", with: "no_user"
          select "Xbox", from: "プラットフォーム"
          check "ダイヤモンド"
          within(".main-field") do
            click_button "検索"
          end
          expect(page).to have_content "該当するユーザーは見つかりませんでした。別の条件で検索してみてください。"
          expect(page).to have_selector(".header-container p , 検索結果：0")
          expect(current_path).to eq search_users_path
        end
      end
    end
  end
end
