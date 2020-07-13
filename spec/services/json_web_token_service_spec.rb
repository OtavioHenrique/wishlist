# frozen_string_literal: true

require "rails_helper"

RSpec.describe JsonWebTokenService do
  subject(:service) { described_class }

  let(:secret_key) { Rails.application.secrets.secret_key_base.to_s }
  let(:expire_time) { 24.hours.from_now }
  let(:test_user_id) { 123 }
  let(:generated_token) { JWT.encode(merged_payload, secret_key) }
  let(:payload) do
    {
      user_id: test_user_id
    }
  end
  let(:merged_payload) do
    {
      user_id: test_user_id,
      expiration: expire_time.to_i
    }
  end

  before do
    Timecop.freeze(expire_time)
  end

  after do
    Timecop.return
  end

  describe ".encode" do
    it "encodes the token on the right way" do
      token = described_class.encode(payload: payload, expiration: expire_time.to_i)

      expect(token).to eq generated_token
    end
  end

  describe ".decode" do
    let(:expected_token) { JWT.encode(merged_payload, secret_key) }

    it "encodes the token on the right way" do
      decoded_payload = described_class.decode(generated_token)

      expect(decoded_payload).to eq merged_payload.stringify_keys
    end
  end
end
