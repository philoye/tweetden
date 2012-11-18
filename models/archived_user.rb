class ArchivedUser
  include MongoMapper::Document

  key :_id, ObjectId
  key :twitter_id, String, :unique => true
  key :name, String
  key :screen_name, String
  key :location, String
  key :description, String
  key :profile_image_url, String
  key :url, String
  key :protected, Boolean
  key :followers_count, Integer
  key :friends_count, Integer
  key :created_at, Time
  key :favourites_count, Integer
  key :utc_offset, Integer
  key :time_zone, String
  key :statuses_count, Integer
  key :listed_count, Integer

  def self.import(user)
    user.rename_key("id","twitter_id")
    user.delete('status')
    ArchivedUser.create(user)
  end

end

