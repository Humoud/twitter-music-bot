class ReplyToMentionJob
  include SuckerPunch::Job

  def perform(handle, msg, tweet_id)
    Bot.reply_to_mention(handle, msg, tweet_id)
  end
end
