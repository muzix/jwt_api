class StreamsController < ApplicationController
  before_action :verify_user
  def create
  end

  private

  def verify_user
    begin
      if auth_params[:auth].split(' ')[0] == 'dev'
        render json: {}, status: 200
      else
        decoded_token = JWT.decode(auth_params[:auth], ENV['DEVISE_JWT_SECRET_KEY'], true)
        render json: {}, status: 200
      end
    rescue Exception
      render json: {}, status: 401
    end
  end

  def auth_params
    params.permit(
      :auth
    )
  end
end
