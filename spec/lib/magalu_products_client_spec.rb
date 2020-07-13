# frozen_string_literal: true

require "rails_helper"

RSpec.describe MagaluProductsClient do
  describe "#find_product" do
    subject(:client) { described_class.new }

    let(:api_response) { file_fixture("magalu_find_response.json").read }
    let(:product_id) { "1bf0f365-fbdd-4e21-9786-da459d78dd1f" }
    let(:expected_response) do
      {
        price: 1699.0,
        image: "http://challenge-api.luizalabs.com/images/1bf0f365-fbdd-4e21-9786-da459d78dd1f.jpg",
        brand: "b\u00e9b\u00e9 confort",
        id: "1bf0f365-fbdd-4e21-9786-da459d78dd1f",
        title: "Cadeira para Auto Iseos B\u00e9b\u00e9 Confort Earth Brown"
      }
    end

    before do
      stub_request(:get, "#{ENV["MAGALU_URL"]}/api/product/#{product_id}/")
        .to_return(body: api_response, headers: { "Content-type" => "application/json" })
    end

    it "makes correct request to API" do
      expect(client.find_product(id: product_id)).to eq(expected_response)
    end
  end
end
