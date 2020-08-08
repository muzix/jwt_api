class StreamsController < ApiController
  def create
    if auth_params[:call] == 'publish'
      verify_user
    elsif auth_params[:call] == 'publish_done'
      try_destroy_stream
      head :ok
    else
      render json: {}, status: 401
    end
  end

  private

  def verify_user
    begin
      auth = auth_params[:auth].split(' ')[0]
      if auth == 'dev'
        try_create_stream
        head :ok
      else
        decoded_token = JWT.decode(auth, ENV['DEVISE_JWT_SECRET_KEY'], true)
        try_create_stream
        head :ok
      end
    rescue Exception => e
      render json: {}, status: 401
    end
  end

  def try_create_stream
    begin
      user = User.find_by_id(auth_params[:name]) || User.first
      server = Server.first_or_create(ip: request.remote_ip)
      Stream.create(user: user, server: server)
    rescue
    end
  end

  def try_destroy_stream
    begin
      user = User.find_by_id(auth_params[:name]) || user = User.first
      server = Server.first_or_create(ip: request.remote_ip)
      Stream.where(user: user, server: server).destroy_all
    rescue
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
