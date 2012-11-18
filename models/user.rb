class User < ActiveRecord::Base

  has_many :tweets, :dependent => :destroy

  def attrs
    OpenStruct.new(JSON.parse(raw))
  end

  def self.import(user)
    user.rename_key("id","twitter_id")
    user.delete('status')
    user = User.find_or_create_by_screen_name(user.screen_name)
    user.raw = user
    puts user
    user.save!
  end

end

