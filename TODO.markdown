TODO
====

* You should be able to jump to each page of results, rather than just next/previous

* Should be able to change sort direction

* Search only handles single word queries

* Retweets and Retweet/User should use MongoMapper::EmbeddedDocument?

* Add ability to browse by month

* Rake import:all should hit the Twitter API only as many times as necessary to get all the user's tweets, rather than just blindly assuming 3200.

* There is no way to update the information for the user. Running `rake import:user` multiple times doesn't update the info.

* Graphs and Stats!

* Support old avatar pics

* Importing directly from Twitter doesn't work on protected users. (WILLNOTFIX)
