class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  validates :self_introduction, length: { maximum: 500 }
  has_one :game_account_info, dependent: :destroy
  accepts_nested_attributes_for :game_account_info
  has_one_attached :avatar

  def self.ransackable_attributes(auth_object = nil)
    ["name"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["game_account_info"]
  end
end
