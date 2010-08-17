before do
  @per_page = 1
  @user = ArchivedUser.first()
  @page  = (params[:page] || 1).to_i
end

get '/search/?' do
  redirect '/'
end

post '/search' do
  redirect "/search/#{params[:query]}"
end

get '/search/:query/?:page?/?' do
  @query = CGI::unescape(params[:query])
  @tweets = ArchivedTweet.sort(:created_at.desc).paginate(:page => @page, :per_page => @per_page, :conditions => {:text => /#{@query}/})
  haml :index
end

get '/:page?/?' do
  @tweets = ArchivedTweet.sort(:created_at.desc).paginate(:page => @page, :per_page => @per_page)
  haml :index
end

not_found do
  haml :not_found
end
error do
  @error = request.env['sinatra.error'].to_s
  haml :error
end unless Sinatra::Application.environment == :development
