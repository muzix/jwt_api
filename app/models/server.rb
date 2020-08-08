class Server < ApplicationRecord
  has_many :streams

  validates :ip, uniqueness: true, presence: true
end
