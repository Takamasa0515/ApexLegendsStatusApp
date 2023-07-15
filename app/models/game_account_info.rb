class GameAccountInfo < ApplicationRecord
  belongs_to :user
  validates :platform, presence: true
  validates :gameid, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["platform", "gameid", "rank"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["user"]
  end
end
