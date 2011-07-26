require 'rubygems'
require 'bundler'

Bundler.require

CLIENTS = []

# TODO refactor to remove duplication with config.ru and remote_hands.rb
APP_ROOT = File.dirname(File.expand_path(__FILE__))
APPLESCRIPTS_PATH = File.join(APP_ROOT, 'applescripts')
RACK_ENV = ENV.fetch('RACK_ENV', 'development')
WEBSOCKETS_CONFIG = {
  :host => ENV.fetch('WEBSOCKET_HOST', `hostname`.chomp),
  :port => ENV.fetch('WEBSOCKET_PORT', '8080')
}

$LOAD_PATH.unshift ::File.expand_path(::File.dirname(__FILE__) + '/lib')

require 'lib/osx'
require 'lib/socket_server'
