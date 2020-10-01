class Room < ApplicationRecord
  has_secure_password
  validates :title, presence: true
  has_many :players
  has_many :users, through: :players

  belongs_to :question
end
