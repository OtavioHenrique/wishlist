# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationController, type: :controller do
  controller(described_class) do
    before_action :authorize_request

    def index
      render json: { response: :ok }, status: :ok
    end
  end

  describe "#authorize_request"  do
    context "when token is expired" do
      let(:token_expiration) { Time.zone.now - 24.hours.to_i }
      let(:token_payload) { { user_id: 1 } }
      let(:expired_token) { JsonWebTokenService.encode(payload: token_payload, expiration: token_expiration) }

      it "returns 401 HTTP status" do
        request.headers["Authorization"] = expired_token

        post :index

        expect(response).to have_http_status(401)
      end
    end

    context "when token is wrong" do
      let(:wrong_token) { "test_token" }

      it "returns 401 HTTP status" do
        request.headers["Authorization"] = wrong_token

        post :index

        expect(response).to have_http_status(401)
      end
    end

    context "when token user doesn't exists" do
      let(:token_payload) { { user_id: 1 } }
      let(:wrong_token) { JsonWebTokenService.encode(payload: token_payload) }

      it "returns 401 HTTP status" do
        request.headers["Authorization"] = wrong_token

        post :index

        expect(response).to have_http_status(401)
      end
    end

    context "when token is valid" do
      let(:user) { create(:user) }
      let(:token_payload) { { user_id: user.id } }
      let(:wrong_token) { JsonWebTokenService.encode(payload: token_payload) }

      it "returns 401 HTTP status" do
        request.headers["Authorization"] = wrong_token

        post :index

        expect(response).to have_http_status(200)
      end
    end
  end
end
