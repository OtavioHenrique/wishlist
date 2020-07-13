# frozen_string_literal: true

require "rails_helper"

RSpec.describe WishListService do
  subject(:wishlist_service) { described_class.new(user: user) }

  let(:products_client) { instance_double(MagaluProductsClient) }

  describe "#add_product" do
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

  describe "#render_products" do
    let(:product_id_1) { "1bf0f365-fbdd-4e21-9786-da459d78dd1f" }
    let(:product_id_2) { "85a09a9e-d1f2-1221-fecb-a850cc4a3a72" }
    let(:product_id_3) { "b3074f84-4f29-ac76-fc8c-088805d429a6" }
    let(:user) do
      create(
        :user,
        wishlist: [
          product_id_1,
          product_id_2,
          product_id_3
        ]
      )
    end

    let(:product_1_response) do
      {
        price: 1699.0,
        id: product_id_1,
        title: "Cadeira"
      }
    end

    let(:product_2_response) do
      {
        price: 800.0,
        id: product_id_2,
        title: "Fone"
      }
    end

    let(:product_3_response) do
      {
        price: 1300.0,
        id: product_id_3,
        title: "Xbox"
      }
    end

    before do
      allow(MagaluProductsClient).to receive(:new).and_return(products_client)
      allow(products_client).to receive(:find_product)
        .with(id: product_id_1).and_return(product_1_response)
      allow(products_client).to receive(:find_product)
        .with(id: product_id_2).and_return(product_2_response)
      allow(products_client).to receive(:find_product)
        .with(id: product_id_3).and_return(product_3_response)
    end

    it "returns all product rendered" do
      expect(wishlist_service.render_products).to eq [product_1_response, product_2_response, product_3_response]
    end
  end
end
