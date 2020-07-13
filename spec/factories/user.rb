# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { "John Doe" }
    email  { "john.doe@test.com" }
    password { "test123" }
  end
end
