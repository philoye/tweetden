$LOAD_PATH << File.dirname(__FILE__)

require 'application'

App.set :run, false

use Rack::Deflater
use Rack::ETag

#Defined in ENV on Heroku. To try locally, start memcached and uncomment:
#ENV["MEMCACHE_SERVERS"] = "localhost"
if memcache_servers = ENV["MEMCACHE_SERVERS"]
  use Rack::Cache,
    verbose: true,
    metastore:   "memcached://#{memcache_servers}",
    entitystore: "memcached://#{memcache_servers}"
end

if ENV['RACK_ENV'] == 'development'
  use Rack::LiveReload
end

run App
