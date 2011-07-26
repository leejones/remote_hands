require 'rubygems'
require 'bundler'

Bundler.require

require 'yaml'

$LOAD_PATH.unshift ::File.expand_path(::File.dirname(__FILE__) + '/lib')

require 'lib/itunes'
require 'lib/osx'

require 'app/remote_hands'
require 'app/say'
require 'app/volume'

APP_ROOT = File.dirname(File.expand_path(__FILE__))
APPLESCRIPTS_PATH = File.join(APP_ROOT, 'applescripts')
RACK_ENV = ENV.fetch('RACK_ENV', 'development')
WEBSOCKETS_CONFIG = {
  :host => ENV.fetch('WEBSOCKET_HOST', `hostname`.chomp),
  :port => ENV.fetch('WEBSOCKET_PORT', '8080')
}

$redis = Redis.new(:host => '127.0.0.1', :port => '6379')