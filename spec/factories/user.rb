# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { "John Doe" }
    email  { "john.doe@test.com" }
    password { "test123" }

    trait :wishlist do
      wishlist do
        %w[1bf0f365-fbdd-4e21-9786-da459d78dd1f c8b8e1c5-2825-51b4-54cb-582d58790e48]
      end
    end
  end
end
