class ServersController < ApiController
  def create
    Server.create(ip: request.remote_ip)
    head :ok
  end

  def detach
    Server.where(ip: request.remote_ip).destroy_all
    head :ok
  end
end
