# frozen_string_literal: true

class User < ApplicationRecord
  validates :email, uniqueness: true, case_sensitive: false
  serialize :wishlist, Array
end
