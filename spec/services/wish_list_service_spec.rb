# frozen_string_literal: true

require "rails_helper"

RSpec.describe WishListService do
  describe "#add_product" do
    subject(:wishlist_service) { described_class.new(user: user) }

    let(:products_client) { instance_double(MagaluProductsClient) }
    let(:id) { "1bf0f365-fbdd-4e21-9786-da459d78dd1f" }
    let(:user) { create(:user) }

    before do
      allow(MagaluProductsClient).to receive(:new).and_return(products_client)
      allow(products_client).to receive(:find_product)
        .with(id: id).and_return(product_response)
    end

    context "when product exists" do
      let(:product_response) do
        {
          price: 1699.0,
          id: id
        }
      end

      it "adds product to user's wishlist" do
        wishlist_service.add_product(id)

        expect(user.wishlist).to include(id)
      end
    end

    context "when product doesn't exists" do
      let(:product_response) do
        {
          error_message: "Product not found",
          code: "not_found"
        }
      end

      it "doesn't include product to wishlist" do
        wishlist_service.add_product(id)

        expect(user.wishlist).not_to include(id)
      end
    end
  end
end
