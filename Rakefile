require 'init'

desc "let's boot this sucker"
task :default do
  exec 'bundle exec shotgun --server thin --host 0.0.0.0 --port 3000 init.rb'

end

task :watch do
  `sass --watch public/scss/screen.scss:public/css/screen.css --scss --style compressed --no-cache`
end

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
      puts "Trying page #{page+1}"
      ArchivedTweet.import( TwitterCom.getTweets(page+1,count) )
      sleep 30
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

task :buildjs do
  require 'open-uri'
  compiler = YUI::JavaScriptCompressor.new
  js = [
    'http://github.com/NV/placeholder.js/raw/gh-pages/placeholder.js'
  ].map {|lib|
    puts "Compiling #{lib}"
    compiler.compress open(lib).read
  }.join("\n")
  File.open('public/js/libs.js','w'){|f| f.write(js)}
end
