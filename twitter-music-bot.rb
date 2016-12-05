require File.join(__dir__, 'config/boot')


puts "app is up and running...\n"
puts "tracking bot with handler: #{BOT_HANDLER}..."
TweetStream::Client.new.track(BOT_HANDLER) do |tweet|
  Bot.save_tweet(tweet)
  puts "Saved a tweet:\t#{tweet.full_text}."
  puts "Issue job that replies to tweet..."
  ReplyToMentionJob.perform_async(
    tweet.user.screen_name, "Test Successful", tweet.id
  )
  puts "Done!"
end
