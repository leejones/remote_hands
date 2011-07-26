require 'rubygems'
require 'bundler'

Bundler.require

CLIENTS = []

# TODO refactor to remove duplication with config.ru
APP_ROOT = File.dirname(File.expand_path(__FILE__))
APPLESCRIPTS_PATH = File.join(APP_ROOT, 'applescripts')

$LOAD_PATH.unshift ::File.expand_path(::File.dirname(__FILE__) + '/lib')

require 'lib/osx'
require 'lib/socket_server'
