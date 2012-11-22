$LOAD_PATH << File.dirname(__FILE__)
ENV['RACK_ENV'] = 'development' unless ENV['RACK_ENV']

require 'sinatra/activerecord/rake'
require 'application'

desc "Converts backed up twitter status xml to json"
task :convert_xml_backup_to_json do
  Dir.glob('backup/*.xml') do |filename|
    f = File.open(filename)
    xml = Nokogiri::XML.parse(f)
    hash = Hash.from_xml(xml.to_xml)
    
    filename[".xml"] = ".json"
    new_file = File.new(filename, "w")
    new_file.write(hash['statuses'].to_json)
    new_file.close
    f.close
  end
end

namespace :migrate do

  task :users do
    u = ArchivedUser.first
    hash = JSON.parse(u.to_json)
    User.record_timestamps = false
    user = User.create(
      :twitter_id  => hash['twitter_id'],
      :screen_name => hash['screen_name'],
      :created_at  => hash['created_at'],
      :updated_at  => hash['created_at'],
      :raw         => hash.to_json
    )
    puts user
    user.save
    User.record_timestamps = true
  end

  task :tweets do
    user = User.first
    Tweet.record_timestamps = false
    ArchivedTweet.each do |tweet|
      hash = JSON.parse(tweet.to_json)
      t = Tweet.create(
        :user_id     => user.id,
        :tweet_id    => hash['twitter_id'],
        :text        => hash['text'],
        :created_at  => hash['created_at'],
        :updated_at  => hash['created_at'],
        :raw         => hash.to_json
      )
      t.save!
    end
    Tweet.record_timestamps = true
  end

end

namespace :import do
  desc "Imports the user"
  task :user do 
    json = TwitterCom.getUser(ENV['TWEETDEN_SCREEN_NAME'])
    User.import(json)
  end

  desc "Imports the last 200 tweets from twitter.com"
  task :latest do
    json = TwitterCom.getTweets(1,200)
    Tweet.import( json )
  end

  desc "Imports up to 3200 tweets from twitter"
  task :all do
    count = 100
    n = 3200 / count
    n.times do |page|
      attempt(5,20) do
        puts "Trying page #{page+1}"
        Tweet.import( TwitterCom.getTweets(page+1,count) )
      end
    end
  end
  
  desc "Imports json from the 'backup' folder"
  task :saved do
    Dir.glob('backup/*.json') do |filename|
      f = File.open(filename)
      Tweet.import( JSON.parse(f.read) )
      f.close
    end
  end
end

namespace :database do
  desc "Copy production database to local"
    task :sync do
      host = ENV['TWEETDEN_MONGO_HOST'] + ENV['TWEETDEN_MONGO_PORT']
      system "mongodump -h #{host} -d tweetden -u #{ENV['TWEETDEN_MONGO_USER']} -p#{ENV['TWEETDEN_MONGO_PASS']} -o db/backups/"
      system 'mongorestore -h localhost --drop -d tweetden db/backups/tweetden/'
  end
end

# heroku calls this
task :cron do
  Rake::Task["import:latest"].invoke
end

