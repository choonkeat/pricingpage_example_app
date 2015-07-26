# config/initializers/pricingpage.rb
# generated and copied from `pricingpage.co > integration`

require 'active_resource' # gem 'activeresource'
require 'tmpdir' # Dir.tmpdir

class Customer < ::ActiveResource::Base
  self.site = "https://choonkeat:f684040b-d433-4e4d-b4ea-fa5726e4e1e5@choonkeat.pricingpage.co/pages/1f12d637-17af-42e3-82a0-76c9e8ba5442"

  # optional helper method
  def subscribed?(plan_title = nil)
    self.subscriptions.find do |subscription|
      if subscription.state == 'subscribed'
        plan_title.nil? || (subscription.plan && (subscription.plan.title == plan_title))
      end
    end
  end

  # optional helper method
  def processing?
    self.subscriptions.find do |subscription|
      subscription.state == 'processing'
    end
  end
end

module ActiveResourceCaching
  extend ActiveSupport::Concern

  included do
    class_attribute :cache
    self.cache = nil
  end

  module ClassMethods
    def cache_with(*store_option)
      self.cache = ActiveSupport::Cache.lookup_store(store_option)
      self.alias_method_chain :get, :cache
    end
  end

  def get_with_cache(path, headers = {})
    cached_resource = self.cache.read(path)
    response = if cached_resource && cached_etag = cached_resource["Etag"]
      get_without_cache(path, headers.merge("If-None-Match" => cached_etag))
    else
      get_without_cache(path, headers)
    end
    return cached_resource if response.code == "304"
    self.cache.write(path, response)
    response
  end
end

ActiveResource::Connection.send :include, ActiveResourceCaching
ActiveResource::Connection.cache_with :file_store, Dir.tmpdir
