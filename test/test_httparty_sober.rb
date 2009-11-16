require 'helper'

class TestHttpartySober < Test::Unit::TestCase
  
  should "define caching class methods when included" do
    assert CacheParty.respond_to?("get_with_caching")
    assert CacheParty.respond_to?("cache")
    assert CacheParty.respond_to?("cache!")
  end
  
  should "set APICache.store" do
    APICache.expects(:store=).with("cache_store")
    CacheParty.cache :store => "cache_store"
  end
  
  should "save and use default caching options" do
    options = {:cache =>123, :valid => 123}
    CacheParty.cache options
    APICache.expects(:get).with("url", options)
    CacheParty.get_with_caching "url"
  end
  
  context "force caching" do
    should "alias get to get_with_caching" do
      klass = class OverwriteGet; include HTTParty; include HTTParty::Sober; end
      klass.cache!
      APICache.expects(:get).with("url", {}).returns("response")
      assert_equal "response", klass.get("url")
    end
  
    should "alias original get class method to get_without_caching" do
      klass = class OriginalGet; include HTTParty; include HTTParty::Sober; end
      APICache.expects(:get).never  
      klass.expects(:perform_request).with(Net::HTTP::Get, "url", {}).returns("response")
      klass.cache!
      assert_equal "response", klass.get_without_caching("url")
    end
  end
  
end
