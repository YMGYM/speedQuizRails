class Room < ApplicationRecord
  has_secure_password
  validates :title, presence: true
end
