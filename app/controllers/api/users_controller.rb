# frozen_string_literal: true

module Api
  class UsersController < ApplicationController
    before_action :find_user, only: %i[show update destroy]

    def create
      user = User.new(user_params)

      if user.save
        render json: user, status: :created
      else
        render json: { errors: user.errors }, status: :unprocessable_entity
      end
    end

    def show
      render json: @user
    end

    def update
      if @user.update(user_params)
        render json: @user, status: :ok
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @user.destroy
    end

    private

    def find_user
      @user = User.find_by id: params[:id]

      render json: { errors: { user: ["doesnt exists"] } }, status: :not_found if @user.nil?
    end

    def user_params
      params.require(:user).permit(:name, :email)
    end
  end
end
