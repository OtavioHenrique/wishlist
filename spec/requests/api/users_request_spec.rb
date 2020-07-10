# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::Users", type: :request do
  describe "POST api/users#create" do
    context "when user creation is successfull" do
      let(:name) { "John Doe" }
      let(:email) { "john.doe@test.com" }
      let(:user_params) do
        {
          user: {
            name: name,
            email: email
          }
        }
      end

      it "returns 201 HTTP code" do
        post "/api/users", params: user_params

        expect(response).to have_http_status(201)
      end

      it "returns the created user" do
        post "/api/users", params: user_params

        user = JSON.parse(response.body)

        expect(user).to include("name" => name, "email" => email, "wishlist" => [])
      end
    end

    context "when user creation fails" do
      before do
        create(:user, email: "john.doe@test.com")
      end

      user_params = {
        user: {
          name: "John Doe",
          email: "john.doe@test.com"
        }
      }

      it "returns 422 HTTP code" do
        post "/api/users", params: user_params

        expect(response).to have_http_status(422)
      end

      it "returns the error" do
        post "/api/users", params: user_params

        error = JSON.parse(response.body)

        expect(error.dig("errors", "email")).to eq ["has already been taken"]
      end
    end
  end

  describe "GET api/users#show" do
    context "when user exists" do
      let(:user) { create(:user) }

      it "returns 200 HTTP code" do
        get "/api/users/#{user.id}"

        expect(response).to have_http_status(200)
      end

      it "returns the user" do
        get "/api/users/#{user.id}"

        expect(response.body).to eq user.to_json
      end
    end

    context "when user doesn't exists" do
      it "returns 404 HTTP code" do
        get "/api/users/100000"

        expect(response).to have_http_status(404)
      end
    end
  end

  describe "PUT api/users#update" do
    context "when updates successfull" do
      let(:user) { create(:user) }
      let(:name) { "test name" }
      let(:email) { "test_email@email.com" }

      let(:params) do
        {
          user: {
            name: name,
            email: email
          }
        }
      end

      it "returns success HTTP code" do
        put "/api/users/#{user.id}", params: params

        expect(response).to have_http_status(200)
      end

      it "returns updated user" do
        put "/api/users/#{user.id}", params: params

        user = JSON.parse(response.body)

        expect(user).to include("name" => name, "email" => email)
      end
    end

    context "when update fail" do
      let(:user) { create(:user) }
      let(:name) { "test name" }
      let(:email) { "test_email@email.com" }

      let(:params) do
        {
          user: {
            name: name,
            email: email,
            undefined_attribute: 42
          }
        }
      end

      before do
        create(:user, email: email)
      end

      it "returns success HTTP code" do
        put "/api/users/#{user.id}", params: params

        expect(response).to have_http_status(422)
      end

      it "returns correct errrorr code" do
        put "/api/users/#{user.id}", params: params

        error = JSON.parse(response.body)

        expect(error["email"]).to eq ["has already been taken"]
      end
    end
  end

  describe "DELETE api/users#destroy" do
    context "when user exists" do
      let(:user) { create(:user) }

      it "returrns success HTTP code" do
        delete "/api/users/#{user.id}"

        expect(response).to have_http_status(204)
      end

      it "deletes user" do
        delete "/api/users/#{user.id}"

        expect(User.find_by(id: user.id)).to be_nil
      end
    end
  end
end
