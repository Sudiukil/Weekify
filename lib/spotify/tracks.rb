# frozen_string_literal: true

require_relative 'request'
require_relative 'api_error'

module Spotify
  # Spotify tracks wrapper class
  class Tracks
    ENDPOINT = 'https://api.spotify.com/v1/tracks'

    def self.get_track(track_id)
      res = Spotify::GetRequest.new.execute("#{ENDPOINT}/#{track_id}")

      raise Spotify::ApiError, res if res.code != '200'

      JSON.parse(res.body)
    end
  end
end
