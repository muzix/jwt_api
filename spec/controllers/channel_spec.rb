require 'rails_helper'

RSpec.describe 'GET /channels', type: :request do

  let(:user) { Fabricate(:user) }
  let(:url) { '/channels' }

  context 'when unauthorized' do
    before do
      get url
    end

    it 'returns 401' do
      expect(response).to have_http_status(401)
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

      get url, headers: { 'Authorization': "#{auth}" }
    end

    it 'returns 200 with channel data' do
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['1']).to eq '2'
    end
  end

end
