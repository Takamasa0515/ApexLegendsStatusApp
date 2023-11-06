require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.build(:user) }

  it "ユーザー名、メールアドレス、パスワードがある場合、有効である事" do
    expect(user).to be_valid
  end

  it "ユーザー名が無い場合、バリデーションエラーを返す事" do
    user.name = nil
    expect(user).to_not be_valid
  end

  it "メールアドレスが無い場合、バリデーションエラーを返す事" do
    user.email = nil
    expect(user).to_not be_valid
  end

  it "メールアドレスが重複している場合、バリデーションエラーを返す事" do
    FactoryBot.create(:user)
    new_user = FactoryBot.build(:user)
    expect(new_user).to_not be_valid
  end

  it "パスワードが無い場合、バリデーションエラーを返す事" do
    user.password = nil
    expect(user).to_not be_valid
  end
end
