class Api::V1::AuthController < ApplicationController

  def create 
    user = User.find_by(email: params[:email])
    if user&authenticate(params[:password])
      token = encode_token({ token: token, user_id: user.id })
      render json: { token: token, role: user.role }, status: :ok
    else
      render json: { error: "Invalid credentials" }, status: :unauthorized
    end
  end

  private

  def encode(payload)
    JWT.encode(payload, Rails.application.secret_key_base, "HSA256")
  end
  
end
