# frozen_string_literal: true

class MagaluProductsClient
  include HTTParty
  logger ::Logger.new STDOUT

  base_uri ENV["MAGALU_URL"]

  def find_product(id:)
    response = self.class.get("/api/product/#{id}/")

    response.parsed_response.deep_symbolize_keys
  end
end
