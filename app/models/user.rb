class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  has_one :game_account_info, dependent: :destroy
  has_one_attached :avatar, dependent: :destroy
  has_many :tracker_match_records, dependent: :destroy

  def self.ransackable_attributes(_auth_object = nil)
    ["name"]
  end

  def self.ransackable_associations(_auth_object = nil)
    ["game_account_info"]
  end

  def self.guest
    if User.exists?(email: 'guest@example.com')
      User.find_by!(email: 'guest@example.com')
    else
      password = SecureRandom.urlsafe_base64
      user = User.create(name: "ゲストアカウント", self_introduction: "ゲストアカウントです。このアカウントにゲームアカウントの登録はできません。", password: password, password_confirmation: password)
      GameAccountInfo.create(platform: "origin", gameid: "Twitch_Ne1u", user_id: user.id)
    end
  end
end
