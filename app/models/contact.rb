class Contact < ApplicationRecord
  validates :name, presence: true
  validates :message, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, format: { with: VALID_EMAIL_REGEX }, if: -> { email.present? }
end
