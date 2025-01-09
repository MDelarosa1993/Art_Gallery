class Api::V1::Admin::OrdersController < ApplicationController
  before_action :authenticate_user
  before_action :authorize_admin


  def index
    orders = Order.includes(:order_items, :user).all
    render json: orders.as_json(include: { order_items: { include: :artwork }, user: { only: [:name, :email] } }), status: :ok
  end
  

  private

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

  def authorize_admin
    render json: { error: 'Access forbidden: Admins only' }, status: :forbidden unless @current_user&.admin?
  end
end
