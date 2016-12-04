require File.join(__dir__, 'config/boot')



TweetStream::Client.new.track("@RobotPawn") do |tweet|
  Bot.save_tweet(tweet)
  puts "Saved a tweet:\t#{tweet.full_text}."
end
