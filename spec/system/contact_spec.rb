require 'rails_helper'

RSpec.describe Contact, type: :system do
  let(:contact) { FactoryBot.create(:contact) }

  describe "お問い合わせフォーム" do
    before do
      contact
      visit new_contact_path
    end

    describe "お問い合わせフォームに遷移した時" do
      context "フォームの入力値が正常な時" do
        it "確認画面に遷移する事" do
          fill_in "お名前", with: contact.name
          fill_in "メールアドレス", with: contact.email
          fill_in "お問い合わせ内容", with: contact.message
          click_button "入力内容確認"
          expect(current_path).to eq confirm_path
        end
      end

      context "お名前が未入力の時" do
        it "名前を入力してくださいと表示される事" do
          fill_in "お名前", with: ""
          fill_in "メールアドレス", with: contact.email
          fill_in "お問い合わせ内容", with: contact.message
          click_button "入力内容確認"
          expect(page).to have_content "名前を入力してください"
          expect(current_path).to eq new_contact_path
        end
      end

      context "お問い合わせ内容が未入力の時" do
        it "お問い合わせ内容を入力してくださいと表示される事" do
          fill_in "お名前", with: contact.name
          fill_in "メールアドレス", with: contact.email
          fill_in "お問い合わせ内容", with: ""
          click_button "入力内容確認"
          expect(page).to have_content "お問い合わせ内容を入力してください"
          expect(current_path).to eq new_contact_path
        end
      end
    end

    describe "確認画面に遷移した時" do
      context "全てのフォームに入力されている時" do
        it "入力内容が表示される事" do
          fill_in "お名前", with: contact.name
          fill_in "メールアドレス", with: contact.email
          fill_in "お問い合わせ内容", with: contact.message
          click_button "入力内容確認"
          expect(page.all(".main-form-right")[0]).to have_content contact.name
          expect(page.all(".main-form-right")[1]).to have_content contact.email
          expect(page.all(".main-form-right")[2]).to have_content contact.message
          expect(current_path).to eq confirm_path
        end
      end

      context "メールアドレスが未入力の場合" do
        it "入力内容が表示され、メールアドレスは未入力となる事" do
          fill_in "お名前", with: contact.name
          fill_in "メールアドレス", with: ""
          fill_in "お問い合わせ内容", with: contact.message
          click_button "入力内容確認"
          expect(page.all(".main-form-right")[0]).to have_content contact.name
          expect(page.all(".main-form-right")[1]).to have_content "未入力"
          expect(page.all(".main-form-right")[2]).to have_content contact.message
          expect(current_path).to eq confirm_path
        end
      end

      context "送信ボタンを押した時" do
        it "送信完了画面に遷移する事" do
          fill_in "お名前", with: contact.name
          fill_in "メールアドレス", with: contact.email
          fill_in "お問い合わせ内容", with: contact.message
          click_button "入力内容確認"
          click_button "送信"
          expect(page).to have_content "送信完了"
          expect(current_path).to eq complete_path
        end
      end

      context "入力画面に戻るボタンを押した時" do
        it "お問い合わせフォームに遷移する事" do
          fill_in "お名前", with: contact.name
          fill_in "メールアドレス", with: contact.email
          fill_in "お問い合わせ内容", with: contact.message
          click_button "入力内容確認"
          click_button "入力画面に戻る"
          expect(current_path).to eq new_contact_path
        end

        it "入力した内容が表示されていること" do
          fill_in "お名前", with: contact.name
          fill_in "メールアドレス", with: contact.email
          fill_in "お問い合わせ内容", with: contact.message
          click_button "入力内容確認"
          click_button "入力画面に戻る"
          expect(page).to have_field "お名前", with: contact.name
          expect(page).to have_field "メールアドレス", with: contact.email
          expect(page).to have_field "お問い合わせ内容", with: contact.message
        end
      end
    end
  end
end
