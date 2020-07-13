# frozen_string_literal: true

class WishListService
  def initialize(user:)
    @user = user
  end

  def add_product(product_id)
    product_response = get_product(product_id)

    @user.wishlist << product_id if product_response[:code].nil?
  end

  private

  def get_product(product_id)
    client.find_product(id: product_id)
  end

  def client
    MagaluProductsClient.new
  end
end
