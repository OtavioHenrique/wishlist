# frozen_string_literal: true

module Api
  class AuthenticationController < ApplicationController
    def login
      @user = User.find_by(email: login_params[:email])

      if @user&.authenticate(login_params[:password])
        token = JsonWebTokenService.encode(payload: token_payload, expiration: token_expiration)

        render json: { token: token, expiration: token_expiration.strftime("%m-%d-%Y %H:%M") }, status: :ok
      else
        render json: { error: "Unauthorized" }, status: :unauthorized
      end
    end

    private

    def login_params
      params.permit(:email, :password)
    end

    def token_expiration
      @token_expiration ||= Time.zone.now + 24.hours.to_i
    end

    def token_payload
      { user_id: @user.id }
    end
  end
end
