# Setup the listed gems in the gemfile
require 'bundler/setup'

# Actually require the gems
Bundler.require

# Set the project root
Nrb.config.root = File.expand_path('..', __dir__)

# Add the root to the load path
$:.unshift(Nrb.root) unless $:.include?(Nrb.root)

# Require other configurations from the config/nrb.rb file
require 'config/nrb'

# Setup ActiveRecord
require 'logger'
ActiveRecord::Base.configurations = YAML.load_file('db/config.yml')
ActiveRecord::Base.establish_connection(:development)
ActiveRecord::Base.logger = Logger.new(STDOUT)

# Finally require files inside resources
Nrb.config.autoload_paths.each do |dir|
  Dir[File.join(dir, '*.rb')].each { |f| require(f) }
end

#################################################
#### TODO: add to YML file
## Twitter Handle and Creds
# @RobotPawn
# DeveloperAccount1!

# Authenticate
twitter_creds = YAML.load_file('config/twitter.yml')
BOT_HANDLER = twitter_creds['bot_handler']

CLIENT = Twitter::REST::Client.new do |config|
  config.consumer_key = twitter_creds['consumer_key']
  config.consumer_secret = twitter_creds['consumer_secret']
  config.access_token = twitter_creds['access_token']
  config.access_token_secret = twitter_creds['access_token_secret']
end

S_CLIENT = TweetStream.configure do |config|
  config.consumer_key = twitter_creds['consumer_key']
  config.consumer_secret = twitter_creds['consumer_secret']
  config.oauth_token        = twitter_creds['access_token']
  config.oauth_token_secret = twitter_creds['access_token_secret']
  config.auth_method        = :oauth
end
