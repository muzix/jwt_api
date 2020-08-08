require 'rails_helper'

RSpec.describe 'POST /server', type: :request do
  let(:url) { '/server' }
  let(:detach_url) { '/server/detach' }

  context 'post server ip' do
    it 'successfully send server ip' do
      post url
      expect(response).to have_http_status(200)
      expect(Server.count).to eq(1)
      expect(Server.first.ip).to eq('127.0.0.1')

      post url
      expect(response).to have_http_status(200)
      expect(Server.count).to eq(1)
      expect(Server.first.ip).to eq('127.0.0.1')

      post detach_url
      expect(response).to have_http_status(200)
      expect(Server.count).to eq(0)
    end
  end
end
