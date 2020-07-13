# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::Authentication", type: :request do
  describe "POST api/authentication#login" do
    let(:email) { "john.doe@test.com" }
    let(:password) { "test12345" }

    before do
      create(:user, email: email, password: password)
    end

    context "when user exists" do
      let(:auth_params) do
        {
          email: email,
          password: password
        }
      end

      it "receives reives 200 HTTP code" do
        post "/api/authentication/login", params: auth_params

        expect(response).to have_http_status(200)
      end

      it "receives the correct token" do
        post "/api/authentication/login", params: auth_params

        json_response = JSON.parse(response.body)

        expect(json_response).to include("token", "expiration")
      end
    end

    context "when user isn't authorized" do
      let(:auth_params) do
        {
          email: email,
          password: "wrong_password"
        }
      end

      it "receives reives 200 HTTP code" do
        post "/api/authentication/login", params: auth_params

        expect(response).to have_http_status(401)
      end
    end
  end
end
