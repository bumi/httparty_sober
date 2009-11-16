require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'mocha'
require 'httparty'
require 'rubygems'
require 'api_cache'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'httparty_sober'

class Test::Unit::TestCase
end

class CacheParty
  include HTTParty
  include HTTParty::Sober
end