# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  validates :email, uniqueness: true, case_sensitive: false
  serialize :wishlist, Array

  def as_json(*)
    super.except("wishlist").tap do |user|
      user["wishlist"] = WishListService.new(user: self).render_products
    end
  end

  def render_wishlist
    WishListService.new(user: self).render_products
  end
end
