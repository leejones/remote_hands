require 'remote_hands'

run Rack::URLMap.new \
  '/'       => Remotehands,
  '/volume' => Volume,
  '/say'    => Say