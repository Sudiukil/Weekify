# frozen_string_literal: true

module Spotify
  # Abstract Request class
  class Request
    def initialize(token = ENV['WEEKIFY_ACCESS_TOKEN'])
      raise 'Bearer token is missing or empty.' if token.nil? || token.empty?

      @token = token
    end

    def execute
      raise NotImplementedError
    end
  end

  # GET request class
  class GetRequest < Request
    def execute(url)
      uri = URI.parse(url)
      request = Net::HTTP::Get.new(uri)
      request['Authorization'] = "Bearer #{@token}"

      Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(request)
      end
    end
  end

  # POST request class
  class PostRequest < Request
    def execute(url, body)
      uri = URI.parse(url)
      request = Net::HTTP::Post.new(uri)
      request['Authorization'] = "Bearer #{@token}"
      request.content_type = 'application/json'
      request.body = body.to_json

      Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(request)
      end
    end
  end
end
