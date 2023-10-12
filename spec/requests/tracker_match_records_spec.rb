require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:game_account_info) { FactoryBot.create(:game_account_info, user: user) }

  describe "GET/user_tracker_match_records" do
    before do
      get user_tracker_match_records_path(user)
    end

    it "getメソッドで通信し、ステータスコード200を返すこと" do
      expect(response).to have_http_status(200)
    end

    it "今月のカレンダーが表示される事" do
      expect(response.body).to include("#{Date.today.month.to_s}月 #{Date.today.year.to_s}")
    end
  end

  describe "GET/user_tracker_show_records" do
    before do
      get user_tracker_show_records_path(user)
    end

    it "getメソッドで通信し、ステータスコード200を返すこと" do
      expect(response).to have_http_status(200)
    end
  end
end
