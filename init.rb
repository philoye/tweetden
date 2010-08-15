$KCODE = "U"

require 'bundler'
Bundler.setup
Bundler.require

require 'open-uri'
include Twitter::Autolink

MongoMapper.database = 'tweetden'
if production?
  MongoMapper.connection = Mongo::Connection.new(ENV['TWEETDEN_MONGO_HOST'], ENV['TWEETDEN_MONGO_PORT'])
  MongoMapper.database.authenticate(ENV['TWEETDEN_MONGO_USER'], ENV['TWEETDEN_MONGO_PASS'])
else
  MongoMapper.connection = Mongo::Connection.new('localhost')
end

['lib','models','controllers'].each do |dir|
  Dir.glob("#{dir}/*.rb") do |filename|
    require filename
  end
end

configure do
  set :views, File.join(File.dirname(__FILE__),'views')
  set :public, File.join(File.dirname(__FILE__),'public')
  set :static, true
  set :haml => {:format => :html5}
  set :sass => {:load_paths => [File.join(Sinatra::Application.public,'scss')]}
end
