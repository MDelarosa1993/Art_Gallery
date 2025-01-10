class Api::V1::UsersController < ApplicationController
  def create
    user = User.new(user_params)
    if user.save 
      render json: { message: "User created!!", user: UserSerializer.new(user)}, status: :created
    else
      render json: ErrorSerializer.format_error(ErrorMessage.new(user.errors.full_messages, 422)), status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :role)
  end
end
