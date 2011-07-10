require 'rubygems'
require 'bundler'

Bundler.require

$LOAD_PATH.unshift ::File.expand_path(::File.dirname(__FILE__) + '/lib')

require 'lib/itunes'
require 'lib/system'

require 'app/remote_hands'
require 'app/say'
require 'app/volume'