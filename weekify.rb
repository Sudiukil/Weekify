# frozen_string_literal: true

require 'logger'
require_relative 'lib/spotify/tracks'
require_relative 'lib/spotify/albums'
require_relative 'lib/spotify/playlists'

module Weekify
  LOGGER = Logger.new($stderr)

  # Main config class for Weekify
  class Config
    CONFIG_PATH = 'config.json'

    def self.read
      JSON.parse(File.read(CONFIG_PATH))
    end
  end

  #  Main service class for Weekify
  class Service
    def self.add_track_album_to_playlist(playlist_id, track_id)
      track = Spotify::Tracks.get_track(track_id)
      album_tracks = Spotify::Albums.get_tracks(track['album']['id'])

      Spotify::Playlists.add_tracks(
        playlist_id,
        album_tracks['items'].map { |item| item['uri'] }
      )
    rescue Spotify::ApiError => e
      LOGGER.error(e)
    end
  end
end
