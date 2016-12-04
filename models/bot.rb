class Bot < ActiveRecord::Base
  def self.search_twitter_for_words(words)
      CLIENT.search(words, lang: "en").first.text
    end

    def self.check_mentions
      puts "Reading mentions..."
      CLIENT.mentions_timeline.each { |tweet|
        # if did_reply_to_mention? tweet.id
          # puts "replied to tweet with id: #{tweet.id}"
        # else
          print_tweet tweet
        # end
      }
    end

    def self.mention(name, msg)
      CLIENT.update("@#{name} #{mg}")
    end

    def self.reply_to_tweet(name, msg, tweet_id)
      CLIENT.update("@#{name} msg", in_reply_to_status_id: tweet_id)
    end

    # def self.did_reply_to_mention?(tweet_id)
    #   if (Tweet.find_by(tweet_id: tweet_id).nil?)
    #     return false
    #   else
    #     return true
    #   end
    # end


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
