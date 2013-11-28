class TwitterCom

  def self.getTweets(page, count)
    token = prepare_access_token
    response = token.request(:get, "https://api.twitter.com/1.1/statuses/user_timeline/#{ENV['SCREEN_NAME']}.json?count=#{count}&include_rts=true&include_entities=true&page=#{page}")
    return JSON.parse(response.body)
  end

  def self.getUser(user)
    token = prepare_access_token
    response = token.request(:get, "https://api.twitter.com/1.1/users/show.json?screen_name=#{user}")
    return JSON.parse(response.body)
  end

  private

  def self.prepare_access_token
    consumer = OAuth::Consumer.new(ENV['CONSUMER_KEY'], ENV['CONSUMER_SECRET'],
      { :site => "http://api.twitter.com",
        :scheme => :header
      })
    token_hash = { :oauth_token => ENV['ACCESS_TOKEN'],
                   :oauth_token_secret => ENV['ACCESS_TOKEN_SECRET']
                 }
    access_token = OAuth::AccessToken.from_hash(consumer, token_hash )
    return access_token
  end

end

