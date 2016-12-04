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
