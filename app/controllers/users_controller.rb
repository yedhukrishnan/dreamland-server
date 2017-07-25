class UsersController < ApplicationController
  def create
    payload = verify_id_token(user_params[:id_token])
    if payload.nil?
      rendor json: { error: 'User verification failed' }, status: :unprocessable_entity
    else
      @user = User.find_or_initialize_by(email: payload['email'])
      @user.name = payload['name']
      if @user.save!
        render json: @user
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:id_token)
  end

  def verify_id_token token
    audience = JWT.decode(token, nil, false).first['aud']
    if(audience == ENV['ANDROID_CLIENT_ID'])
      validator = GoogleIDToken::Validator.new(expiry: 1800)
      return validator.check(token, audience)
    end
    false
  end
end
