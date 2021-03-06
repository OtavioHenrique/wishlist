# frozen_string_literal: true

Rails.application.routes.draw do
  get "/healthcheck", to: ->(_env) { [200, {}, ["OK"]] }

  namespace :api do
    post "/authentication/login", to: "authentication#login"
    resources :users, only: %i[show create update destroy]

    post "users/wishlist", to: "users#add_wishlist"
    get "users/wishlist/render", to: "users#wishlist"
  end
end
