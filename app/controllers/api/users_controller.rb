# frozen_string_literal: true

module Api
  class UsersController < ApplicationController
    before_action :authorize_request, except: :create

    def create
      user = User.new(user_params)

      if user.save
        render json: user, status: :created
      else
        render json: { errors: user.errors }, status: :unprocessable_entity
      end
    end

    def show
      render json: @current_user
    end

    def update
      if @current_user.update(user_params)
        render json: @current_user, status: :ok
      else
        render json: @current_user.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @current_user.destroy
    end

    private

    def user_params
      params.require(:user).permit(:name, :email, :password)
    end
  end
end
