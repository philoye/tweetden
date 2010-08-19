before do
  @per_page = 50
  @direction = params[:direction] || "desc"
  @user = ArchivedUser.first()
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

get '/' do
  @page  = (params[:page] || 1).to_i
  @tweets = ArchivedTweet.sort(:created_at.send(@direction)).paginate(:page => @page, :per_page => @per_page)
  haml :index
end

not_found do
  haml :not_found
end
error do
  @error = request.env['sinatra.error'].to_s
  haml :error
end unless Sinatra::Application.environment == :development
