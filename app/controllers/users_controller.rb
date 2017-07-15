class UsersController < ApplicationController
  def create
    @user = User.find_or_initialize_by(email: user_params[:email])
    @user.name = user_params[:name]
    @user.auth_token = SecureRandom.hex
    if @user.save!
      render json: @user
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
