# Twitter Music Bot

A twitter bot that searches for song names, artist names, and lyrics.
It queries the `Chart Lyrics` API to do the music search.

## Dependencies
* Ninja Ruby
* SuckerPunch Worker
* Twitter API
* Twitter Steam API
* Active Record

## Usage
1. Create file `config/twitter.yml`.
2. Enter your Twitter bot handle(@xyz), and Twitter API tokens and keys into `config/twitter.yml`:

    ```
    bot_handler: '@account'
    consumer_key: 'xyz123'
    consumer_secret: 'xyz123'
    access_token: 'xyz123'
    access_token_secret: 'xyz123'
    ```

3. start the app `bundle exec nrb start`.

## How it Works
The main script `twitter-music-bot.rb` keeps listing to the twitter stream, it looks for tweets with the bot handle in them. If it founds one, an event is created and the call back function in the main script is executed. The callback function uses the SuckerPunch worker `ReplyToMentionJob` to do the music searching.

The `ReplyToMentionJob` worker then uses the methods in the `Bot` model.

Most of the logic that is related to replying to tweets is located in the Bot model, `bot.rb`.

#### Bot.rb

Methods:
1. save_tweet: saves tweet in SQLite DB
2. reply_to_mention_direct_search: takes in song name and artist, replies with lyrics
3. reply_to_mention_search_lyric: takes in lyrics, replies with the possible song names and artists in multiple tweets.


## Docker
Added a Dockerfile. Now you can run this in a docker container.
run:
1. `docker build -t twitter-bot .` to build the image
2. `docker run -it twitter-bot` to run a container


## TODO
1. Break up lyrics into multiple tweets and then send them.
