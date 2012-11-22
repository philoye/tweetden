class Tweet < ActiveRecord::Base

  belongs_to :user
  validates_uniqueness_of :tweet_id

  def self.search_for(query)
    if query.present?
      where("text @@ :q", q: query)
    else
      scoped
    end
  end

  def self.import(statuses)
    user = nil
    statuses.each do |tweet|
      hash = JSON.parse(tweet.to_json)

      unless user
        user = User.find_by_twitter_id(hash['user']['id'])
        user.raw = hash['user'].to_json
        user.save
      end

      Tweet.record_timestamps = false
      t = Tweet.find_or_create_by_tweet_id(
        :tweet_id    => hash['id_str'],
        :text        => hash['text'],
        :created_at  => hash['created_at'],
        :updated_at  => hash['created_at'],
        :raw         => hash.to_json,
        :user_id     => user.id
      )
      Tweet.record_timestamps = true
    end
  end

  def attrs
    OpenStruct.new(JSON.parse(raw))
  end

end

