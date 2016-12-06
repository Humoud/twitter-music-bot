class ReplyToMentionJob
  include SuckerPunch::Job

  def perform(tweet)
    Bot.reply_to_mention_search_lyric(tweet)
  end
end
