require 'rails_helper'

RSpec.describe 'GET /streams', type: :request do

  let(:user) { Fabricate(:user) }
  let(:url) { '/streams/' }

  context 'when unauthorized' do
    before do
      get url
    end

    it 'returns 401' do
      expect(response).to have_http_status(401)
    end
  end

  context 'when invalid token' do
    before do
      get url, params: { auth: 'dummy_auth' }
    end

    it 'returns 401' do
      expect(response).to have_http_status(401)
    end
  end

  context 'when dev token' do
    before do
      get url, params: { auth: 'dev' }
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

      get url, params: { auth: auth.split(' ')[1] }
    end

    it 'returns 200 with channel data' do
      expect(response).to have_http_status(200)
    end
  end

end
