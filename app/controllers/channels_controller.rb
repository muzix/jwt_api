class ChannelsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    render json: { '1' => '2' }, status: 200
  end
end
