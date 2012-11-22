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
    statuses.each do |status|
      status.rename_key("id","twitter_id")
      status.delete('user')
      Tweet.create(status)
    end
  end

  def attrs
    OpenStruct.new(JSON.parse(raw))
  end

end

