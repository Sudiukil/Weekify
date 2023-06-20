#!/usr/bin/env ruby
# frozen_string_literal: true

require 'sinatra'
require_relative 'lib/spotify/authentication'
require_relative 'weekify'

SCOPE = 'playlist-modify-public playlist-modify-private'
CONFIG = Weekify::Config.read

set :bind, '0.0.0.0'
set :port, 7532

get '/authorize' do
  redirect Spotify::Authentication.authorization_url(
    ENV['WEEKIFY_CLIENT_ID'],
    SCOPE
  )
end

get '/callback' do
  auth = Spotify::Authentication.authorization(
    ENV['WEEKIFY_CLIENT_ID'],
    ENV['WEEKIFY_CLIENT_SECRET'],
    params['code']
  )

  ENV['WEEKIFY_ACCESS_TOKEN'] = auth['access_token']
  ENV['WEEKIFY_REFRESH_TOKEN'] = auth['refresh_token']

  'Authorization complete! You can close this window.'
end

get '/weekify/add/:track_id' do
  Weekify::Service.add_track_album_to_playlist(
    CONFIG['target_playlist'],
    params['track_id']
  )

  halt 204
end
