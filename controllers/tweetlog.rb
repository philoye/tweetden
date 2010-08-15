before do
  @user = ArchivedUser.first()
end

get '/search/?' do
  redirect '/'
end

post '/search' do
  redirect "/search/#{params[:query]}"
end

get '/search/:query/?:page?/?' do
  @page  = (params[:page] || 1).to_i
  @query = CGI::unescape(params[:query])
  @tweets = ArchivedTweet.search(@query, :order => "created_at desc", :page => @page, :paginate => true)
  haml :index
end

get '/:page?/?' do
  @page  = (params[:page] || 1).to_i
  skip_count  = ((@page - 1) * 100)
  @tweets = ArchivedTweet.sort(:created_at.desc).skip(skip_count).limit(100).all
  haml :index
end

not_found do
  haml :not_found
end
error do
  @error = request.env['sinatra.error'].to_s
  haml :error
end unless Sinatra::Application.environment == :development
