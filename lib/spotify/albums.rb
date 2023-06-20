# frozen_string_literal: true

require_relative 'request'
require_relative 'api_error'

module Spotify
  # Spotify albums wrapper class
  class Albums
    ENDPOINT = 'https://api.spotify.com/v1/albums'

    def self.get_tracks(album_id)
      res = Spotify::GetRequest.new.execute("#{ENDPOINT}/#{album_id}/tracks?limit=50")

      raise Spotify::ApiError, res if res.code != '200'

      JSON.parse(res.body)
    end
  end
end
