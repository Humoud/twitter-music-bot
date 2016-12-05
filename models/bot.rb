###### Models am working with:
# Tweet(id: integer, message: string, replied: boolean)
#
# User(id: integer, handle: string, twitter_user_id: integer, tweet_id: integer)

require 'uri'
require 'net/http'

class Bot < ActiveRecord::Base

  def self.save_tweet(tweet)
    t = Tweet.new(message: tweet.full_text, replied: false)


    User.new(handle: "7mood_one", twitter_user_id: 123123, tweet_id: 11)
    user = User.create(handle: tweet.user.screen_name, twitter_user_id: tweet.user.id,
                tweet_id: tweet.id)

    t.user = user
    t.save
  end

  def self.reply_to_mention(handle, msg, tweet_id)
    CLIENT.update("@#{handle} #{msg}", in_reply_to_status_id: tweet_id)
  end

  def get_lyrics_via_artist_and_song_name(tweet)
    tweet_txt = tweet.text
    tweet_txt.sub!("#{BOT_HANDLER} ", "")

    artist_txt = 
    song_txt =

    url_str = "http://api.chartlyrics.com/apiv1.asmx/SearchLyricDirect?"
    url = URI("#{url_str}artist=brand%20new&song=jesus%20christ")

    http = Net::HTTP.new(url.host, url.port)

    request = Net::HTTP::Get.new(url)

    response = http.request(request)

    # TODO parse to XML
    puts response.read_body
  end
  # def self.search_twitter_for_words(words)
  #   CLIENT.search(words, lang: "en").first.text
  # end
  #
  # def self.check_mentions
  #   puts "Reading mentions..."
  #   CLIENT.mentions_timeline.each { |tweet|
  #     # if did_reply_to_mention? tweet.id
  #       # puts "replied to tweet with id: #{tweet.id}"
  #     # else
  #       print_tweet tweet
  #     # end
  #   }
  # end
  #
  # def self.mention(name, msg)
  #   CLIENT.update("@#{name} #{mg}")
  # end
  #
  # def self.reply_to_tweet(name, msg, tweet_id)
  #   CLIENT.update("@#{name} msg", in_reply_to_status_id: tweet_id)
  # end
  #
  # # def self.did_reply_to_mention?(tweet_id)
  # #   if (Tweet.find_by(tweet_id: tweet_id).nil?)
  # #     return false
  # #   else
  # #     return true
  # #   end
  # # end


  private
    # removes html entities from tweet text then prints it out
    def self.print_tweet(tweet)
      if tweet.full_text.include? "&"
        puts HTMLEntities.new.decode("#{tweet.full_text.to_s}")
        #puts HTMLEntities.new.decode("#{tweet.full_text.to_s}\nID: #{tweet.id}\nUser: #{tweet.user.name}\nUser: #{tweet.user.id}User: #{tweet.user.handle}")
      else
        puts "#{tweet.full_text.to_s}\n"
      end
    end
end
