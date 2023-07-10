class GameAccountInfo < ApplicationRecord
  belongs_to :user
  validates :platform, presence: true
  validates :gameid, presence: true
end
