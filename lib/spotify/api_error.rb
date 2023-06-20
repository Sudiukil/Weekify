# frozen_string_literal: true

module Spotify
  # Error class for handling unsucessful API responses
  class ApiError < StandardError
    def initialize(response)
      @code = response.code
      @body = JSON.parse(response.body)

      super(@body['error']['message'] || "Spotify API returned an unexpected #{@code}")
    end
  end
end
