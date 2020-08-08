require 'rails_helper'

RSpec.describe 'post /streams', type: :request do

  let(:user) { create(:user) }
  let(:url) { '/streams/' }

  context 'when unauthorized' do
    before do
      post url
    end

    it 'returns 401' do
      expect(response).to have_http_status(401)
    end
  end

  context 'when invalid token' do
    before do
      post url, params: { auth: 'dummy_auth' }
    end

    it 'returns 401' do
      expect(response).to have_http_status(401)
    end
  end

  context 'when dev token' do
    before do
      post url, params: { auth: 'dev' }
    end

    it 'returns 200' do
      expect(response).to have_http_status(200)
    end
  end

  context 'when authorize' do
    let(:login_url) { '/users/login' }
    let(:params) do
      {
        user: {
          email: user.email,
          password: user.password
        }
      }
    end

    before do
      post login_url, params: params
      expect(response).to have_http_status(200)
      auth = response.headers['Authorization']
      expect(auth).to be_present
      auths = auth.split(' ')

      post url, params: { auth: auths[1] + ' live_103666444_xiAx4AzmyMNNZAIbTZ5ngAC3eMAXsR aa aa',
                          name: user.id}
    end

    it 'returns 200 with channel data' do
      expect(response).to have_http_status(200)
      expect(Stream.count).to eq(1)
      expect(Stream.first.user).to eq(user)
      expect(Stream.first.server.ip).to eq('127.0.0.1')
    end
  end

end
