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
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.name = "ゲストアカウント"
      user.password = SecureRandom.urlsafe_base64
      user.password_confirmation = user.password
    end
  end
end
