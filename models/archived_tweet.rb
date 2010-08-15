class ArchivedTweet
  include MongoMapper::Document

  key :_id, ObjectId
  key :twitter_id, String, :unique => true
  key :created_at, Time
  key :text, String
  key :source, String
  key :truncated, String
  key :in_reply_to_status_id, String
  key :in_reply_to_user_id, String
  key :in_reply_to_screen_name, String
  key :favorited, String

  has_search :text

  def self.import(statuses)
    statuses.each do |status|
      status.rename_key("id","twitter_id")
      status.delete('user')
      ArchivedTweet.create(status)
    end
  end

end
