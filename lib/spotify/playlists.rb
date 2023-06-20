# frozen_string_literal: true

require_relative 'request'
require_relative 'api_error'

module Spotify
  # Spotify playlists wrapper class
  class Playlists
    ENDPOINT = 'https://api.spotify.com/v1/playlists'

    def self.add_tracks(playlist_id, uris)
      res = Spotify::PostRequest.new.execute("#{ENDPOINT}/#{playlist_id}/tracks", { uris: uris })

      raise Spotify::ApiError, res if res.code != '201'

      JSON.parse(res.body)
    end
  end
end
