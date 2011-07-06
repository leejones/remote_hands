require 'rubygems'
require 'bundler'

Bundler.require

require 'remotehands'
require 'vendor/plugins/volume/volume'

run Rack::URLMap.new \
  '/'       => Remotehands,
  '/volume' => Volume