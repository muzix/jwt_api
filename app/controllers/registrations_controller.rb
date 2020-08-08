class RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    user = User.new(user_params)
    if user.save
      sign_in(user)
      render json: user, status: 200
    else
      render json: { errors: user.errors }, status: 400
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :email)
  end
end
