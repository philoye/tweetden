require 'bundler'
ENV['RACK_ENV'] = 'development' unless ENV['RACK_ENV']
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

    register Sinatra::ActiveRecordExtension
    register Sinatra::CompassSupport
    register Sinatra::AssetPack
    register Sinatra::Partial
    register Sinatra::Contrib
    register WillPaginate::Sinatra

    enable :partial_underscores

    db = URI.parse(ENV['DATABASE_URL'] || "postgres://localhost/tweetden_#{ENV['RACK_ENV']}")
    ActiveRecord::Base.establish_connection(
      :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
      :host     => db.host,
      :port     => db.port,
      :username => db.user,
      :password => db.password,
      :database => db.path[1..-1],
      :encoding => 'utf8'
    )

    #MongoMapper.database = 'tweetden'
    #if ENV['RACK_ENV'] == :production
      #MongoMapper.connection = Mongo::Connection.new(ENV['TWEETDEN_MONGO_HOST'], ENV['TWEETDEN_MONGO_PORT'])
      #MongoMapper.database.authenticate(ENV['TWEETDEN_MONGO_USER'], ENV['TWEETDEN_MONGO_PASS'])
    #else
      #MongoMapper.connection = Mongo::Connection.new('localhost')
    #end
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

    js :jsforhead, [
      '/js/modernizr.js',
      '/js/respond.js'
    ]
    js :application, [
      '/js/jquery.js',
      '/js/underscore.js',
      '/js/console.js'
    ]
    css :application, [
      '/css/*.css'
    ]
    expires 86400*365, :public
  }

  before do
    @page   = (params[:page] || 1).to_i
    @per_page = 50
    @direction = params[:direction] || "desc"
    @user = User.first()
  end

  get '/' do
    cache_control :public, :must_revalidate, :max_age => 3600
    if params[:query]
      @query = CGI::unescape(params[:query])
      @tweets = Tweet.search_for(@query)
      params.except!("splat", "captures")
    else
      @tweets = Tweet
    end
    @count = @tweets.count
    @tweets = @tweets.order("created_at #{@direction}").paginate(:page => @page, :per_page => 50)
    haml :index
  end

  post '/' do
    redirect "/?query=#{CGI::escape(params[:query])}"
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

