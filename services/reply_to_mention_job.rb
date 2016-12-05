class ReplyToMentionJob
  include SuckerPunch::Job

  def perform(tweet)
    tweet_txt = tweet.text.sub(/^@\w*\s/, "")

    artist_txt = tweet_txt.split("\n")[1].gsub(" ", "%20")
    song_txt = tweet_txt.split("\n")[0].gsub(" ", "%20")

    url_str = "http://api.chartlyrics.com/apiv1.asmx/SearchLyricDirect?"
    url = URI("#{url_str}artist=#{artist_txt}&song=#{song_txt}")

    http = Net::HTTP.new(url.host, url.port)

    request = Net::HTTP::Get.new(url)

    response = http.request(request)

    doc = Nokogiri::XML(response.read_body)
    response_hash = Hash.from_xml(doc.to_s)

    puts "====\n\nHash: #{response_hash["GetLyricResult"]}\n\n====\n\n"
    lyrics = response_hash["GetLyricResult"]["Lyric"][0..120]
    if response_hash["GetLyricResult"]["Lyric"].blank?
      CLIENT.update("@#{tweet.user.screen_name} Sorry :(\ncouldn't find the lyrics", in_reply_to_status_id: tweet.id)
    else
      CLIENT.update("@#{tweet.user.screen_name} #{lyrics}", in_reply_to_status_id: tweet.id)
    end
  end
end
