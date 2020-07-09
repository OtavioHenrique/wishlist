# frozen_string_literal: true

class User < ApplicationRecord
  validate :email, uniqueness: true
  serialize :wishlist, Array
end
