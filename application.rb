require 'bundler'
Bundler.require(:default, ENV['RACK_ENV'])

require 'open-uri'
include Twitter::Autolink

class App < Sinatra::Base

  configure do
    env = ENV['RACK_ENV'] || 'development'
    enable   :logging
    enable   :raise_errors

    set      :root, File.dirname(__FILE__)
    set      :sass, { :load_paths => [ "#{App.root}/app/css" ] }
    set      :haml, :format => :html5

    register Sinatra::CompassSupport
    register Sinatra::AssetPack
    register Sinatra::Partial
    register Sinatra::Contrib

    enable :partial_underscores

    MongoMapper.database = 'tweetden'
    if ENV['RACK_ENV'] == :production
      MongoMapper.connection = Mongo::Connection.new(ENV['TWEETDEN_MONGO_HOST'], ENV['TWEETDEN_MONGO_PORT'])
      MongoMapper.database.authenticate(ENV['TWEETDEN_MONGO_USER'], ENV['TWEETDEN_MONGO_PASS'])
    else
      MongoMapper.connection = Mongo::Connection.new('localhost')
    end
  end

  # Load files
  (
   Dir['./lib/*.rb'].sort +
   Dir['./models/*.rb'].sort
  ).uniq.each { |rb| require rb }

  configure :development do |config|
    require "sinatra/reloader"
    register Sinatra::Reloader
    enable   :show_exceptions
  end

  assets {
    serve '/images', from: 'app/images'
    serve '/js',     from: 'app/js'
    serve '/css',    from: 'app/css'

    js :application, [
      '/js/jquery.js'
    ]
    css :application, [
      '/css/*.css'
    ]
    expires 86400*365, :public
  }

  before do
    @per_page = 50
    @direction = params[:direction] || "desc"
    @user = ArchivedUser.first()
  end

  get '/' do
    cache_control :public, :must_revalidate, :max_age => 3600
    @page  = (params[:page] || 1).to_i
    @tweets = ArchivedTweet.sort(:created_at.send(@direction)).paginate(:page => @page, :per_page => @per_page)
    haml :index
  end

  get '/search/?' do
    redirect '/'
  end

  post '/search' do
    redirect "/search/#{CGI::escape(params[:query])}"
  end

  get '/search/:query' do
    @page  = (params[:page] || 1).to_i
    @query = CGI::unescape(params[:query])
    query_regex = @query.split(" ").join("|")
    @tweets = ArchivedTweet.sort(:created_at.send(@direction)).paginate(:page => @page, :per_page => @per_page, :conditions => {:text => /(#{query_regex})/i})
    params.delete("query") # Search term doesn't need to be in the query string.
    haml :index
  end

  get 'favicon.ico' do
    ""
  end

  not_found do
    haml :not_found
  end
  error do
    @error = request.env['sinatra.error'].to_s
    haml :error
  end unless Sinatra::Application.environment == :development

end

