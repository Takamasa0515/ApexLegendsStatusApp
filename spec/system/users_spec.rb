require 'rails_helper'

RSpec.describe Users, type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:registered_user) { FactoryBot.create(:registered_user) }
  let(:guest_user) { FactoryBot.create(:guest_user) }

  before do
    guest_user
  end

  describe "ログインしていない時" do
    describe "ユーザー新規登録" do
      context "フォームの入力値が正常の時" do
        it "ユーザーの新規作成が成功する事" do
          visit new_user_registration_path
          fill_in "ユーザー名", with: "テストユーザー"
          fill_in "Eメール", with: "test@example.com"
          fill_in "パスワード(6文字以上)", with: "password"
          fill_in "パスワード（確認用）", with: "password"
          click_button "新規登録"
          expect(page).to have_content "アカウント登録が完了しました。"
          user = User.find_by(email: "test@example.com")
          expect(current_path).to eq user_path(user.id)
        end
      end
      context "ユーザー名が未入力の時" do
        it "ユーザーの新規作成が失敗する事" do
          visit new_user_registration_path
          fill_in "ユーザー名", with: ""
          fill_in "Eメール", with: "test@example.com"
          fill_in "パスワード(6文字以上)", with: "password"
          fill_in "パスワード（確認用）", with: "password"
          click_button "新規登録"
          expect(page).to have_content "ユーザー名を入力してください"
          expect(current_path).to eq new_user_registration_path
        end
      end
      context "メールアドレスが未入力の時" do
        it "ユーザーの新規作成が失敗する事" do
          visit new_user_registration_path
          fill_in "ユーザー名", with: "テストユーザー"
          fill_in "Eメール", with: ""
          fill_in "パスワード(6文字以上)", with: "password"
          fill_in "パスワード（確認用）", with: "password"
          click_button "新規登録"
          expect(page).to have_content "Eメールを入力してください"
          expect(current_path).to eq new_user_registration_path
        end
      end
      context "パスワードが未入力の時" do
        it "ユーザーの新規作成が失敗する事" do
          visit new_user_registration_path
          fill_in "ユーザー名", with: "テストユーザー"
          fill_in "Eメール", with: "test@example.com"
          fill_in "パスワード(6文字以上)", with: ""
          fill_in "パスワード（確認用）", with: ""
          click_button "新規登録"
          expect(page).to have_content "パスワードを入力してください"
          expect(current_path).to eq new_user_registration_path
        end
      end
      context "パスワードが6文字未満の時" do
        it "ユーザーの新規作成が失敗する事" do
          visit new_user_registration_path
          fill_in "ユーザー名", with: "テストユーザー"
          fill_in "Eメール", with: "test@example.com"
          fill_in "パスワード(6文字以上)", with: "pass"
          fill_in "パスワード（確認用）", with: "pass"
          click_button "新規登録"
          expect(page).to have_content "パスワードは6文字以上で設定してください"
          expect(current_path).to eq new_user_registration_path
        end
      end
      context "確認用パスワードが一未入力の時" do
        it "ユーザーの新規作成が失敗する事" do
          visit new_user_registration_path
          fill_in "ユーザー名", with: "テストユーザー"
          fill_in "Eメール", with: "test@example.com"
          fill_in "パスワード(6文字以上)", with: "password"
          fill_in "パスワード（確認用）", with: ""
          click_button "新規登録"
          expect(page).to have_content "パスワード（確認用）がパスワードと一致しません"
          expect(current_path).to eq new_user_registration_path
        end
      end
      context "確認用パスワードが一致しない時" do
        it "ユーザーの新規作成が失敗する事" do
          visit new_user_registration_path
          fill_in "ユーザー名", with: "テストユーザー"
          fill_in "Eメール", with: "test@example.com"
          fill_in "パスワード(6文字以上)", with: "password"
          fill_in "パスワード（確認用）", with: "different_password"
          click_button "新規登録"
          expect(page).to have_content "パスワード（確認用）がパスワードと一致しません"
          expect(current_path).to eq new_user_registration_path
        end
      end
      context "登録済のメールアドレスを使用" do
        it "ユーザーの新規作成が失敗する" do
          user
          visit new_user_registration_path
          fill_in "ユーザー名", with: "テストユーザー"
          fill_in "Eメール", with: user.email
          fill_in "パスワード(6文字以上)", with: "password"
          fill_in "パスワード（確認用）", with: "password"
          click_button "新規登録"
          expect(page).to have_content "Eメールはすでに登録されています"
          expect(current_path).to eq new_user_registration_path
        end
      end
    end

    describe "ユーザーログイン" do
      before do
        user
      end
      context "フォームの入力値が正常の時" do
        it "ログインができる事" do
          visit new_user_session_path
          fill_in "Eメール", with: user.email
          fill_in "パスワード", with: user.password
          click_button "ログインする"
          expect(page).to have_content "ログインしました。"
          expect(current_path).to eq user_path(user.id)
        end
      end
      context "メールアドレスが未入力の時" do
        it "ログインが失敗する事" do
          visit new_user_session_path
          fill_in "Eメール", with: ""
          fill_in "パスワード", with: user.password
          click_button "ログインする"
          expect(page).to have_content "Eメールまたはパスワードが違います"
          expect(current_path).to eq new_user_session_path
        end
      end
      context "メールアドレスが一致しない時" do
        it "ログインが失敗する事" do
          visit new_user_session_path
          fill_in "Eメール", with: "different_test@example.com"
          fill_in "パスワード", with: user.password
          click_button "ログインする"
          expect(page).to have_content "Eメールまたはパスワードが違います"
          expect(current_path).to eq new_user_session_path
        end
      end
      context "パスワードが味入力の時" do
        it "ログインが失敗する事" do
          visit new_user_session_path
          fill_in "Eメール", with: user.email
          fill_in "パスワード", with: ""
          click_button "ログインする"
          expect(page).to have_content "Eメールまたはパスワードが違います"
          expect(current_path).to eq new_user_session_path
        end
      end
      context "パスワードが一致しない時" do
        it "ログインが失敗する事" do
          visit new_user_session_path
          fill_in "Eメール", with: user.email
          fill_in "パスワード", with: "different_password"
          click_button "ログインする"
          expect(page).to have_content "Eメールまたはパスワードが違います"
          expect(current_path).to eq new_user_session_path
        end
      end
    end

    describe "パスワード再設定メールフォーム" do
      before do
        user
        visit new_user_password_path
      end

      context "フォームの入力値が正常の時" do
        it "メールが送信される事" do
          fill_in "Eメール", with: user.email
          click_button "パスワード再設定メールを送信"
          expect(page).to have_content "パスワードの再設定について数分以内にメールでご連絡いたします。"
          expect(current_path).to eq new_user_session_path
          expect(ActionMailer::Base.deliveries.size).to eq(1)
        end
      end

      context "フォームが未入力の時" do
        it "メールが送信されない事" do
          click_button "パスワード再設定メールを送信"
          expect(page).to have_content "Eメールを入力してください"
          expect(current_path).to eq new_user_password_path
        end
      end

      context "メールアドレスが見つからない時" do
        it "メールが送信されない事" do
          fill_in "Eメール", with: "different_test@example.com"
          click_button "パスワード再設定メールを送信"
          expect(page).to have_content "Eメールは見つかりませんでした。"
          expect(current_path).to eq new_user_password_path
        end
      end
    end

    describe "パスワード再設定フォーム" do
      before do
        user
        @token = Devise.friendly_token
        user.reset_password_token = Devise.token_generator.digest(self, :reset_password_token, @token)
        user.reset_password_sent_at = Time.zone.now
        user.save!
      end

      describe "トークンが有効期限内の時" do
        before do
          visit "#{edit_user_password_path}?reset_password_token=#{@token}"
        end

        context "フォームの入力値が正常の時" do
          it "パスワードが更新される事" do
            fill_in "新しいパスワード(6文字以上)", with: "new_userpassword"
            fill_in "パスワード（確認用）", with: "new_userpassword"
            click_button "パスワードを再設定"
            expect(page).to have_content "パスワードが正しく変更されました。"
            expect(current_path).to eq user_path(user)
            expect(user.reload.valid_password?("new_userpassword")).to be true
          end
        end

        context "フォームが未入力の時" do
          it "パスワードが更新されない事" do
            fill_in "新しいパスワード(6文字以上)", with: ""
            fill_in "パスワード（確認用）", with: ""
            click_button "パスワードを再設定"
            expect(page).to have_content "パスワードを入力してください"
            expect(current_path).to eq edit_user_password_path
          end
        end

        context "新しいパスワードが6文字未満の時" do
          it "パスワードが更新されない事" do
            fill_in "新しいパスワード(6文字以上)", with: "pass"
            fill_in "パスワード（確認用）", with: "pass"
            click_button "パスワードを再設定"
            expect(page).to have_content "パスワードは6文字以上で設定してください"
            expect(current_path).to eq edit_user_password_path
          end
        end

        context "確認用パスワードが未入力の時" do
          it "パスワードが更新されない事" do
            fill_in "新しいパスワード(6文字以上)", with: "new_userpassword"
            fill_in "パスワード（確認用）", with: ""
            click_button "パスワードを再設定"
            expect(page).to have_content "パスワード（確認用）がパスワードと一致しません"
            expect(current_path).to eq edit_user_password_path
          end
        end

        context "確認用パスワードが違う時" do
          it "パスワードが更新されない事" do
            fill_in "新しいパスワード(6文字以上)", with: "new_userpassword"
            fill_in "パスワード（確認用）", with: "different_userpassword"
            click_button "パスワードを再設定"
            expect(page).to have_content "パスワード（確認用）がパスワードと一致しません"
            expect(current_path).to eq edit_user_password_path
          end
        end
      end

      describe "存在しないトークンの時" do
        it "トークンが一致しませんと表示される事" do
          visit "#{edit_user_password_path}?reset_password_token=not_exist_token"
          fill_in "新しいパスワード(6文字以上)", with: "new_userpassword"
          fill_in "パスワード（確認用）", with: "new_userpassword"
          click_button "パスワードを再設定"
          expect(page).to have_content "パスワードリセット用トークンが一致しません"
          expect(current_path).to eq edit_user_password_path
        end
      end

      describe "トークンが有効期限外の時" do
        it "有効期限が切れていると表示される事" do
          user.reset_password_sent_at = Time.zone.now - 1800
          user.save!
          visit "#{edit_user_password_path}?reset_password_token=#{@token}"
          fill_in "新しいパスワード(6文字以上)", with: "new_userpassword"
          fill_in "パスワード（確認用）", with: "new_userpassword"
          click_button "パスワードを再設定"
          expect(page).to have_content "パスワードリセット用トークンの有効期限が切れました。新しくリクエストしてください。"
          expect(current_path).to eq edit_user_password_path
        end
      end
    end
  end

  describe "ログインしている時" do
    before do
      guest_user
      user
      sign_in user
    end

    context "ログアウトをクリックした時" do
      it "確認ダイアログが表示される事" do
        visit edit_user_registration_path
        click_link "ログアウト"
        expect(page.accept_confirm).to eq "ログアウトしますか？"
      end

      it "ログアウトできる事" do
        visit edit_user_registration_path
        click_link "ログアウト"
        page.accept_confirm
        expect(page).to have_content "ログアウトしました。"
        expect(current_path).to eq root_path
      end
    end

    describe "プロフィール編集" do
      context "アイコン画像をアップロードする時" do
        it "正常にアップロードでき、表示される事" do
          visit edit_user_registration_path
          attach_file "user[avatar]", Rails.root.join('spec/fixtures/image/test_avatar.jpg').to_s
          fill_in "現在のパスワード", with: user.password
          click_button "更新する"
          expect(page).to have_content "アカウント情報を変更しました。"
          expect(page).to have_selector("img.user-avatar, img[src$='test_avatar.jpg']")
        end
      end
      context "アイコン画像をアップロードしない時" do
        it "デフォルト画像が表示される事" do
          visit edit_user_registration_path
          fill_in "現在のパスワード", with: user.password
          click_button "更新する"
          expect(page).to have_content "アカウント情報を変更しました。"
          expect(page).to have_selector("img.user-avatar, img[src$='default_avatar.jpg']")
        end
      end
      context "フォームの入力値が正常" do
        it "プロフィールの編集が成功する事" do
          visit edit_user_registration_path
          fill_in "ユーザー名", with: "Updateテストユーザー"
          fill_in "プロフィール", with: "テストユーザーです。"
          fill_in "Eメール", with: "Update_test@example.com"
          fill_in "現在のパスワード", with: user.password
          click_button "更新する"
          expect(page).to have_content "アカウント情報を変更しました。"
          expect(current_path).to eq user_path(user.id)
        end
      end
      context "ユーザー名が未入力の時" do
        it "プロフィールの編集が失敗する事" do
          visit edit_user_registration_path
          fill_in "ユーザー名", with: ""
          fill_in "プロフィール", with: "テストユーザーです。"
          fill_in "Eメール", with: user.email
          fill_in "現在のパスワード", with: user.password
          click_button "更新する"
          expect(page).to have_content "ユーザー名を入力してください"
          expect(current_path).to eq edit_user_registration_path
        end
      end
      context "登録済みのメールアドレスが入力された時" do
        it "プロフィールの編集が失敗する事" do
          registered_user
          visit edit_user_registration_path
          fill_in "ユーザー名", with: user.name
          fill_in "プロフィール", with: "テストユーザーです。"
          fill_in "Eメール", with: registered_user.email
          fill_in "現在のパスワード", with: user.password
          click_button "更新する"
          expect(page).to have_content "Eメールはすでに登録されています"
          expect(current_path).to eq edit_user_registration_path
        end
      end
      context "現在のパスワードが未入力の時" do
        it "プロフィールの編集が失敗する事" do
          visit edit_user_registration_path
          fill_in "ユーザー名", with: user.name
          fill_in "プロフィール", with: "テストユーザーです。"
          fill_in "Eメール", with: user.email
          fill_in "現在のパスワード", with: ""
          click_button "更新する"
          expect(page).to have_content "現在のパスワードを入力してください"
          expect(current_path).to eq edit_user_registration_path
        end
      end
      context "現在のパスワードが間違っている時" do
        it "プロフィールの編集が失敗する事" do
          visit edit_user_registration_path
          fill_in "ユーザー名", with: user.name
          fill_in "プロフィール", with: "テストユーザーです。"
          fill_in "Eメール", with: user.email
          fill_in "現在のパスワード", with: "different_password"
          click_button "更新する"
          expect(page).to have_content "現在のパスワードが一致しません"
          expect(current_path).to eq edit_user_registration_path
        end
      end
    end
  end
end
