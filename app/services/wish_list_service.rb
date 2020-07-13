# frozen_string_literal: true

class WishListService
  def initialize(user:)
    @user = user
  end

  def add_product(product_id)
    product_response = get_product(product_id)

    @user.wishlist << product_id if product_response[:code].nil?
    @user.save!

    Rails.logger.info("Added product #{product_id} to user #{@user.id} wishlist")

    @user
  end

  def render_products
    @user.wishlist.map do |product|
      product_response = get_product(product)

      Rails.logger.error("Product #{product} doesn't exists") if product_response[:code].present?

      product_response
    end
  end

  private

  def get_product(product_id)
    client.find_product(id: product_id)
  end

  def client
    MagaluProductsClient.new
  end
end
