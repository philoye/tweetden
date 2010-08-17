TODO
====

* Pagination is pretty useless right now (it always shows "previous" even if there are no records to show). You should be able to jump to each page of results.

* Number of results for search should be much higher (100).

* Search itself is *very* limited. At the very least, it would be nice to be able to change sort direction. Maybe filter to show/exclude retweets.

* Add ability to browse by month

* Rake import:all should hit the Twitter API only as many times as necessary to get all the user's tweets, rather than just blindly assuming 3200.

* There is no way to update the information for the user. Running `rake import:user` multiple times doesn't update the info.

* Rake import:all doesn't handle Twitter rate limiting, connection timeouts, etc. To work around this (and to be nice to the API), it only pulls 100 at a time and sleeps 30 seconds between requests. If it still blows up, just keep re-running the rake task. It'll grab them all eventually and won't result in duplicates.

* Graphs and Stats!

* Support old avatar pics

* Importing directly from Twitter doesn't work on protected users. (WILLNOTFIX)
