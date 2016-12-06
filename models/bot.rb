###### Models am working with:
# Tweet(id: integer, message: string, replied: boolean)
#
# User(id: integer, handle: string, twitter_user_id: integer, tweet_id: integer)

## TODO set field `replied_to` of the tweets that the bot has replied to true

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

  # Expects:
  # First line of tweet = Song name
  # Second line of tweet = Artist name
  def self.reply_to_mention_direct_search(tweet)
    # Remove bot handle from tweet
    tweet_txt = tweet.text.sub(/^@\w*\s/, "")
    # Get artist and song from tweet
    artist_txt = tweet_txt.split("\n")[1].gsub(" ", "%20")
    song_txt = tweet_txt.split("\n")[0].gsub(" ", "%20")

    # Prepare URL for request http
    url_str = "http://api.chartlyrics.com/apiv1.asmx/SearchLyricDirect?"
    url = URI("#{url_str}artist=#{artist_txt}&song=#{song_txt}")
    # Make http request
    response = make_http_request(url)
    response_hash = make_hash(response.read_body)

    puts "====\n\nHash: #{response_hash["GetLyricResult"]}\n\n====\n\n"

    if response_hash["GetLyricResult"]["Lyric"].blank?
      CLIENT.update("@#{tweet.user.screen_name} Sorry :(\ncouldn't find the lyrics", in_reply_to_status_id: tweet.id)
    else
      lyrics = nil
      if response_hash["GetLyricResult"]["Lyric"].length > 120
        lyrics = response_hash["GetLyricResult"]["Lyric"][0..120]
      else
        lyrics = response_hash["GetLyricResult"]["Lyric"]
      end
      CLIENT.update("@#{tweet.user.screen_name} #{lyrics}", in_reply_to_status_id: tweet.id)
    end
  end

  # Expects:
  # the whole tweet contains just lyrics
  # and of course the first part of the tweet is the bot twitter handler
  # just removed in the first line in the method  using regex
  def self.reply_to_mention_search_lyric(tweet)
    # Remove bot handle from tweet
    tweet_txt = tweet.text.sub(/@\w*\s*/, "")

    url_str = "http://api.chartlyrics.com/apiv1.asmx/SearchLyricText?"
    url = URI("#{url_str}lyricText=#{tweet_txt}")
    res = make_http_request(url)
    res_hash = make_hash(res.read_body)

    # if nothing found
    if res_hash["ArrayOfSearchLyricResult"]["SearchLyricResult"].count == 1
      CLIENT.update("@#{tweet.user.screen_name} Sorry :(\ncouldn't find the song name and artist", in_reply_to_status_id: tweet.id)
    else
      reply_arr = []
      temp_txt = ""
      res_hash["ArrayOfSearchLyricResult"]["SearchLyricResult"].each { |entry|
        if entry.nil?
          reply_arr.push(temp_txt)
          next
        end
        if temp_txt.length > 60
          reply_arr.push(temp_txt)
          temp_txt = "#{entry["Song"]} - #{entry["Artist"]}"
        else
          temp_txt = "#{temp_txt}\n#{entry["Song"]} - #{entry["Artist"]}"
        end
      }
      reply_arr.each { |tweet_msg|
        CLIENT.update("@#{tweet.user.screen_name} #{tweet_msg}", in_reply_to_status_id: tweet.id)
      }
    end
  end

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

    def self.make_hash(response_body)
      doc = Nokogiri::XML(response_body)
      response_hash = Hash.from_xml(doc.to_s)
      return response_hash
    end

    def self.make_http_request(url)
      http = Net::HTTP.new(url.host, url.port)
      request = Net::HTTP::Get.new(url)
      response = http.request(request)
      return response
    end
end
