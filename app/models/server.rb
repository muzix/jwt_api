class Server < ApplicationRecord
  validates :ip, uniqueness: true, presence: true
end
