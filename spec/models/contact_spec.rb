require 'rails_helper'

RSpec.describe Contact, type: :model do
  describe "メールアドレスの正規表現についてのバリデーション" do

    contact = FactoryBot.create(:contact)

    it "メールアドレスの形式が正しい場合、通過する事" do
      expect(contact).to be_valid
    end

    it "メールアカウントがない場合、通過しない事" do
      contact.email = "@example.com"
      expect(contact).to be_invalid
    end

    it "メールアカウントに全角の文字が含まれる場合、通過しない事" do
      contact.email = "テスト@example.com"
      expect(contact).to be_invalid
    end

    it "@がない場合、通過しない事" do
      contact.email = "testexample.com"
      expect(contact).to be_invalid
    end

    it "ドメインがない場合、通過しない事" do
      contact.email = "test@"
      expect(contact).to be_invalid
    end

    it "ドメインにピリオドがない場合、通過しない事" do
      contact.email = "test@examplecom"
      expect(contact).to be_invalid
    end

    it "ドメインに全角の文字が含まれる場合、通過しない事" do
      contact.email = "test@example.コム"
      expect(contact).to be_invalid
    end
  end
end
