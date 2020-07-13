# frozen_string_literal: true

class ApplicationController < ActionController::API
  def authorize_request
    begin
      if expired_token
        render_unauthorized("Expired Token")
      else
        @current_user = User.find(decoded[:user_id])
      end
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound => e
      render_unauthorized(e.message)
    end
  end

  private

  def authorization_token
    request.headers["Authorization"]
  end

  def decoded
    JsonWebTokenService.decode(authorization_token)
  end

  def expired_token
    Time.zone.now > decoded[:expiration]
  end

  def render_unauthorized(message)
    render json: { errors: message }, status: :unauthorized
  end
end
