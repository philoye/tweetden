TWEETLOG
========

TweetDen provides a personal Twitter archive, including a backup of your tweets and a basic front-end for browsing/searching. It is along the lines of [Tweet Nest](http://pongsocket.com/tweetnest/), but in Ruby.

By changing one environment variable `ENV['TWEETDEN_SCREEN_NAME']`, this app can be *your* personal twitter archive.


HOW IT WORKS
------------

TweetDen is built in [Sinatra](http://sinatrarb.com) and uses Postgres as the backend. I then use [Heroku](http://heroku.com) to host it, which you can [see here](http://log.philoye.com/), but you can host it whereever.

Currently, the app does not talk to the Twitter API directly during the request. Instead you use a series of Rake tasks to populate the database. To keep it up to date, you would call `rake import:latest` via a cron job whenever you'd like (daily, hourly, etc.).


GETTING STARTED
---------------

1. Install the gems. Run `bundle install`


2. Add an environment variable called `TWEETDEN_SCREEN_NAME`. I recommend adding to your `.bashrc` by including something like:

        export SCREEN_NAME=philoye


3. Bootstrap the application. Run a couple of Rake commands:

        rake import:user
        rake import:all

    First it hits the Twitter API to grab info about the user. Then it attempts to pull down all the tweets available via the Twitter API.


4. (Optional) If you have any saved tweets, you can import them locally. Create a `backup` directory at the project root. Include any xml or json files that represent the output of the `user_timeline` API method. Again, you only need to do this if you have saved tweets that fall outside the 3200 maximum. The last 3200 were imported directly from Twitter via the previous step.

    An easy way to backup your tweets is via a web browser directly from Twitter. Go to the following URL and save the output. Just insert your screen name and change `page=1` to `page=2`, etc. up to `page=16` to grab 3200 tweets (200 is the max per request).

    [http://api.twitter.com/1/statuses/user_timeline/YOUR_SCREEN_NAME.json?count=200&include_rts=true&include_entities=true&page=1](http://api.twitter.com/1/statuses/user_timeline/philoye.json?count=200&include_rts=true&include_entities=true&page=1)

    The import task assumes json. If you have xml files, run the following rake task first, which will create json files in the same directory (it won't overwrite the xml):

        rake convert_xml_backup_to_json

    Then import the saved tweets by running:

        rake import:saved


5. Boot the app by entering the following in a terminal:

        bundle exec foreman start



WHERE ARE ALL MY TWEETS?
------------------------

The Twitter API only exposes the last 3200 tweets, so if you have more than that, you're pretty much screwed. However, if you had the foresight to backup the XML/JSON before hitting 3200 tweets, then you can use the included Rake task to import them.


NOW WHAT?
---------

Give it a go and let me know how it works out. Follow [@tweetdenapp](http://twitter.com/tweetdenapp) for updates and for support. You can also follow [@philoye](http://twitter.com/philoye) if you're so inclined.


LICENSE
-------

Copyright (c) 2010 Phil Oye

TweetDen is covered by the MIT License. See [LICENSE](http://github.com/philoye/tweetden/blob/master/LICENSE) for more information.

