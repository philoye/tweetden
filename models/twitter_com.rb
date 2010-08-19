class TwitterCom

  def self.getTweets(page, count)
    f = open("http://api.twitter.com/1/statuses/user_timeline/#{ENV['TWEETDEN_SCREEN_NAME']}.json?count=#{count}&include_rts=true&include_entities=true&page=#{page}").read
    return JSON.parse(f)
  end

  def self.getUser(user)
    f = open("http://api.twitter.com/1/users/show.json?screen_name=#{user}").read
    return JSON.parse(f)
  end

end
