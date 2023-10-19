require 'rails_helper'

RSpec.describe GameAccountInfo, type: :model do
  let(:user) { FactoryBot.build(:user) }
  let(:game_account_info) { FactoryBot.build(:game_account_info, user: user) }

  it "プラットフォーム、ゲームIDがある場合、有効である事" do
    expect(game_account_info).to be_valid
  end

  it "プラットフォームがない場合、バリデーションエラーを返す事" do
    game_account_info.platform = nil
    expect(game_account_info).to_not be_valid
  end

  it "ゲームIDがない場合、バリデーションエラーを返す事" do
    game_account_info.gameid = nil
    expect(game_account_info).to_not be_valid
  end
end
