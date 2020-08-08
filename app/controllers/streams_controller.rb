class StreamsController < ApiController
  before_action :verify_user
  def create
    if auth_params[:call] == 'publish'
      verify_user
    elsif auth_params[:call] == 'publish_done'
      user = User.find(auth_params[:name])
      server = Server.where(ip: request.remote_ip).first
      Stream.where(user: user, server: server).destroy_all
    end
  end

  private

  def verify_user
    begin
      auth = auth_params[:auth].split(' ')[0]
      if auth == 'dev'
        render json: {}, status: 200
      else
        decoded_token = JWT.decode(auth, ENV['DEVISE_JWT_SECRET_KEY'], true)
        begin
          user = User.find(auth_params[:name])
          server = Server.first_or_create(ip: request.remote_ip)
          Stream.create(user: user, server: server)
        rescue
        end
        head :ok
      end
    rescue Exception => e
      render json: {}, status: 401
    end
  end

  def auth_params
    params.permit(
      :auth,
      :call,
      :name
    )
  end
end
