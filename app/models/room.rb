class Room < ApplicationRecord
  has_secure_password
  validates :title, presence: true
  has_many :players, :dependent => :destroy
  has_many :users, through: :players, :dependent => :destroy

  belongs_to :question
end
