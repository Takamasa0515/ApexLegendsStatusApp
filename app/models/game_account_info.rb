class GameAccountInfo < ApplicationRecord
  belongs_to :user
  validates :platform, presence: true
  validates :gameid, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    ["platform", "gameid", "rank"]
  end

  def self.ransackable_associations(_auth_object = nil)
    ["user"]
  end
end
