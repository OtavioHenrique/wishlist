# frozen_string_literal: true

Rails.application.routes.draw do
  get "/healthcheck", to: ->(_env) { [200, {}, ["OK"]] }
end
