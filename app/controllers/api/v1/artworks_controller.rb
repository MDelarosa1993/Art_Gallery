class Api::V1::ArtworksController < ApplicationController
  before_action :authenticate_user
  
  def index
    artworks = @current_user.artworks 
    render json: artworks, status: :ok
  end

  def create
    artwork = @current_user.artworks.new(artwork_params)
    if artwork.save
      render json: artwork, status: :created
    else
      render json: { errors: artwork.errors.full_messages}, status: :unproccessable_entity
    end
  end

  private

  def artwork_params
    params.require(:artwork).permit(:title, :description, :price)
  end

  def authenticate_user
    token = request.headers['Authorization']&.split(' ')&.last
    return render json: { error: 'Token missing or invalid' }, status: :unauthorized unless token

    begin
      decoded_token = JWT.decode(token, Rails.application.secret_key_base, true, { algorithm: 'HS256' })
      user_id = decoded_token[0]['user_id']
      @current_user = User.find(user_id)
    rescue JWT::DecodeError
      render json: { error: 'Invalid token' }, status: :unauthorized
    end
  end
end
