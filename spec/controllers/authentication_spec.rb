require 'rails_helper'

RSpec.describe 'POST /users/login', type: :request do
  let(:user) { Fabricate(:user) }
  let(:url) { '/users/login' }
  let(:params) do
    {
      user: {
        email: user.email,
        password: user.password
      }
    }
  end

  context 'when params are correct' do
    before do
      post url, params: params
    end

    it 'returns 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns JTW token in authorization header' do
      expect(response.headers['Authorization']).to be_present
    end

    it 'returns valid JWT token' do
      token_from_request = response.headers['Authorization'].split(' ').last
      decoded_token = JWT.decode(token_from_request, ENV['DEVISE_JWT_SECRET_KEY'], true)
      expect(decoded_token.first['sub']).to be_present
    end
  end

  context 'when login params are incorrect' do
    before { post url, params: params }
    let(:params) do
      {
        user: {
          email: user.email,
          password: user.password + '12'
        }
      }
    end

    it 'returns unathorized status' do
      expect(response.status).to eq 401
      expect(response.body).to eq 'Invalid Email or password.'
    end
  end
end

RSpec.describe 'DELETE /users/logout', type: :request do
  let(:url) { '/users/logout' }

  it 'returns 200' do
    delete url
    expect(response).to have_http_status(200)
  end
end
