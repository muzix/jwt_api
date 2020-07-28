require 'rails_helper'

RSpec.describe 'POST /users/signup', type: :request do
  let(:url) { '/users/signup' }
  let(:params) do
    {
      user: {
        email: 'user@example.com',
        password: 'password'
      }
    }
  end

  context 'when user is unauthenticated' do
    before { post url, params: params }

    it 'returns 200' do
      expect(response.status).to eq 200
    end

    it 'returns valid JWT token' do
      token_from_request = response.headers['Authorization'].split(' ').last
      decoded_token = JWT.decode(token_from_request, ENV['DEVISE_JWT_SECRET_KEY'], true)
      expect(decoded_token.first['sub']).to be_present
    end

    it 'create a new user' do
      expect(User.first.email).to eq(params[:user][:email])
    end
  end

  context 'when user already exists' do
    before do
      Fabricate(:user, email: params[:user][:email])
      post url, params: params
    end

    it 'returns bad request status' do
      expect(response.status).to eq 400
    end

    it 'returns validation errors' do
      expect(JSON.parse(response.body)['errors']['email']).to include('has already been taken')
    end
  end
end
