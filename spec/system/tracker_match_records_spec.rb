require 'rails_helper'

RSpec.describe TrackerMatchRecord, type: :system do
  let(:user) { FactoryBot.create(:user) }
  #let(:registered_user) { FactoryBot.create(:registered_user) }
  let(:guest_user) { FactoryBot.create(:guest_user) }
  let(:game_account_info) { FactoryBot.create(:game_account_info, user: user) }
end
