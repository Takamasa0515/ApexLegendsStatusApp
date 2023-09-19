require "rails_helper"

RSpec.describe ContactMailer, type: :mailer do
  let(:contact) { FactoryBot.create(:contact) }
  let(:mail) { ContactMailer.send_mail(contact) }
  describe "お問い合わせメールの送信" do
    context "メールを送信した時" do
      it "メールタイトルが正しい事" do
        expect(mail.subject).to eq "お問い合わせがありました。"
      end

      it "メールの送信先が正しい事" do
        expect(mail.to).to eq [ENV.fetch('TOMAIL', nil)]
      end

      it "メールの送信元が正しい事" do
        expect(mail.from).to eq ['contact@example.com']
      end

      it "お問い合わせ本文にお問い合わせ者のメールアドレスがある事" do
        expect(mail.body).to have_content contact.email
      end

      it "メールアドレスが入力されなかった場合、お問い合わせ者のメールアドレスが未入力になる事" do
        contact.email = nil
        expect(mail.body).to have_content "未入力"
      end

      it "お問い合わせ本文にお問い合わせ者の氏名がある事" do
        expect(mail.body).to have_content "#{contact.name}様からお問い合わせがありました。"
      end

      it "お問い合わせ内容が正しい事" do
        expect(mail.body).to have_content contact.message
      end
    end
  end
end
