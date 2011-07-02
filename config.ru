require 'rubygems'
require 'bundler'

Bundler.require

use Rack::Static,
  :urls => ["/images", "/javascripts", "/stylesheets"],
  :root => "public"

require './remotehands'
run Remotehands