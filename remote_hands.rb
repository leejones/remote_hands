require 'rubygems'
require 'bundler'

Bundler.require

$LOAD_PATH.unshift ::File.expand_path(::File.dirname(__FILE__) + '/lib')

require 'lib/itunes'
require 'lib/osx'

require 'app/remote_hands'
require 'app/say'
require 'app/volume'

APP_ROOT = File.dirname(File.expand_path(__FILE__))
APPLESCRIPTS_PATH = File.join(APP_ROOT, 'applescripts')

$redis = Redis.new(:host => '127.0.0.1', :post => 6379)