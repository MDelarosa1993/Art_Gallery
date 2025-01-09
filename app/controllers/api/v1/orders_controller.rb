class Api::V1::OrdersController < ApplicationController
  before_action :authenticate_user
  before_action :authorize_buyer
  
  def create
    order = @current_user.orders.new(order_params)
    if order.save
      render json: order.as_json(include: :order_items), status: :created
    else
      render json: { errors: order.errors.full_messages}, status: :unprocessable_entity
    end
  end

  private

  def order_params
    params.require(:order).permit(:total_price, order_items_attributes: [:artwork_id, :quantity, :price])
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

  def authorize_buyer
    unless @current_user&.buyer?
      render json: { error: 'Access forbidden: Buyers only' }, status: :forbidden
    end
  end
end
