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

namespace :import do
  desc "Imports the user"
  task :user do 
    json = TwitterCom.getUser(ENV['TWEETDEN_SCREEN_NAME'])
    ArchivedUser.import(json)
  end

  desc "Imports the last 200 tweets from twitter.com"
  task :latest do
    xml = TwitterCom.getTweets(1,200)
    ArchivedTweet.import( xml )
  end

  desc "Imports up to 3200 tweets from twitter"
  task :all do
    count = 100
    n = 3200 / count
    n.times do |page|
      attempt(5,20) do
        puts "Trying page #{page+1}"
        ArchivedTweet.import( TwitterCom.getTweets(page+1,count) )
      end
    end
  end
  
  desc "Imports json from the 'backup' folder"
  task :saved do
    Dir.glob('backup/*.json') do |filename|
      f = File.open(filename)
      ArchivedTweet.import( JSON.parse(f.read) )
      f.close
    end
  end
end

# heroku calls this
task :cron do
  Rake::Task["import:latest"].invoke
end

