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

    def add_wishlist
      product_id = params["product_id"]

      WishListService.new(user: @current_user).add_product(product_id)

      render status: :ok
    end

    def wishlist
      render json: @current_user.render_wishlist, status: :ok
    end

    private

    def user_params
      params.require(:user).permit(:name, :email, :password)
    end
  end
end
