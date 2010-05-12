require 'digest/md5'
module HTTParty
  module Sober
    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      @@cache_store = nil
      @@cache_options = {}
      
      def cache(cache_options={})
        @@cache_store = cache_options.delete(:store)
        APICache.store = @@cache_store if @@cache_store
        @@cache_options = cache_options
      end
      
      def cache!(cache_options={})
        cache(cache_options)
        self.instance_eval do
          alias :get_without_caching :get
          alias :get :get_with_caching
        end
      end
      
      def get_with_caching(path, options={})
        cache_options = (@@cache_options || {}).merge(options[:cache] || {})
        query = options[:query] ||= {}
        key = Digest::MD5.hexdigest("#{path.to_s}-#{query.collect{|e| e.join("=")}.join("&")}")
        APICache.get(key,cache_options) do 
          perform_request(Net::HTTP::Get, path, options)
        end
      end
    end
  end
end
   