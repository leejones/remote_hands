require 'rubygems'
require 'bundler'

Bundler.require

require 'remotehands'
require 'vendor/plugins/volume/volume'
require 'vendor/plugins/say/say'

run Rack::URLMap.new \
  '/'       => Remotehands,
  '/volume' => Volume,
  '/say'    => Say