# frozen_string_literal: true

require 'net/http'
require 'json'
require 'base64'
require 'uri'

module Spotify
  # Spotify authentication wrapper class
  class Authentication
    REDIRECT_URI = "#{ENV['WEEKIFY_ROOT_URL']}/callback"
    AUTH_URL = URI('https://accounts.spotify.com/authorize')
    TOKEN_URL = URI('https://accounts.spotify.com/api/token')

    def self.authorization_url(client_id, scope)
      AUTH_URL.query = URI.encode_www_form(
        response_type: 'code',
        client_id: client_id,
        scope: scope,
        redirect_uri: REDIRECT_URI
      )

      AUTH_URL
    end

    def self.authorization(client_id, client_secret, auth_code)
      request = Net::HTTP::Post.new(TOKEN_URL)
      request.basic_auth(client_id, client_secret)
      request.set_form_data(
        grant_type: 'authorization_code',
        code: auth_code,
        redirect_uri: REDIRECT_URI
      )

      response = Net::HTTP.start(TOKEN_URL.hostname, TOKEN_URL.port, use_ssl: true) do |http|
        http.request(request)
      end

      raise "Error: #{response.code} - #{response.body}" if response.code != '200'

      JSON.parse(response.body)
    end
  end
end
