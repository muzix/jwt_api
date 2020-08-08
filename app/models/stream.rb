class Stream < ApplicationRecord
  belongs_to :user
  belongs_to :server

  def play_url
    "http://#{server.ip}/#{name||user.name}.m3u8"
  end
end
