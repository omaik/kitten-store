# frozen_string_literal: true

module KittensStore
  module Routes
    class Landing < Sinatra::Application
      get '/' do
        'Welcome! This is the best Kittens Store in the world! V6'
      end
    end
  end
end
