TWEETLOG
========

TweetDen provides a personal Twitter archive, including a backup of your tweets and provides a basic front-end for browsing/searching. It is along the lines of [Tweet Nest](http://pongsocket.com/tweetnest/), but in Ruby.

By changing one environment variable `ENV['TWEETDEN_SCREEN_NAME']`, this app can be *your* personal twitter archive.


DISCLAIMER
----------

It is very much early days for TweetDen. It has a pretty lengthy [to do list](http://github.com/philoye/tweetden/blob/master/TODO.readme), but it is usable/useful in its current incarnation, hence the release.


HOW IT WORKS
------------

TweetDen is built in [Sinatra](http://sinatrarb.com) and uses [MongoDB](http://mongodb.org) as the backend. I then use [Heroku](http://heroku.com) and [MongoHQ](http://mongohq.com) to host the thing which you can [see here](http://log.philoye.com/), but you can host it where ever.

Currently, the app does not talk to the Twitter API directly during the request. Instead you use a series of Rake tasks to populate the database. To keep it up to date, you would call `rake import:latest` via a cron job whenever you'd like (daily, hourly, etc.).


GETTING STARTED
---------------

1. Get MongoDB up and running. If you're on a Mac, use the very excellent [Homebrew](http://github.com/mxcl/homebrew).

        brew install mongodb


2. Install the gems. Run `bundle install`. I don't really understand Bundler, but that should just work.


3. Add an environment variable called `TWEETDEN_SCREEN_NAME`. I recommend adding to your .bashrc by including something like:

        export TWEETDEN_SCREEN_NAME=philoye


4. Bootstrap the application. Run a couple of Rake commands:

        rake import:user
        rake import:all
     
  First it hits the Twitter API to grab info about the user. Then it attempts to pull down all the tweets available via the Twitter API.
  

5. (Optional) If you have any saved tweets, you can import them locally. Create a `backup` directory at the project root. Include any xml or json files that represent the output of the `user_timeline` API method. Again, you only need to do this if you have saved tweets that fall outside the 3200 maximum. The last 3200 were imported directly from Twitter via the previous step.
  
  An easy way to backup your tweets is via a web browser directly from Twitter. Go to the following URL and save the output. Just insert your screen name and change `page=1` to `page=2`, etc. up to `page=16` to grab 3200 tweets (200 is the max per request).

  [http://twitter.com/statuses/user_timeline/YOUR_SCREEN_NAME.json?count=200&trim_user=true&include_rts=true&include_entities=true&page=1](http://twitter.com/statuses/user_timeline/philoye.json?count=200&trim_user=true&include_rts=true&include_entities=true&page=1)

  The import task assumes json. If you have xml files, run the following rake task first, which will create json files in the same directory (it won't overwrite the xml):
    
        rake convert_xml_backup_to_json
    
  Then import the saved tweets by running:
  
        rake import:saved


6. Boot the app by entering the following in a terminal:

        rake



WHERE ARE ALL MY TWEETS?
------------------------

The Twitter API only exposes the last 3200 tweets, so if you have more than that, you're pretty much screwed. However, if you had the foresight to backup the XML/JSON before hitting 3200 tweets, then you can use the included Rake task to import them.


NOW WHAT?
---------

Give it a go and let me know how it works out. Follow [@tweetdenapp](http://twitter.com/tweetden) for updates.


LICENSE
-------

This software is licensed under the MIT license.
