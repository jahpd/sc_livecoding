require "#{File.dirname(__FILE__)}/githubclient"
require "#{File.dirname(__FILE__)}/searchs"

# This can be everything you want
# for our research we target the 
# following words:
# "livecoding", "live-coding", 
# "webpot", "webaudioapi"
include Client::GithubSearch

# Now search
SEARCHS.each do |q|
  # Initialize our client
  # needs some github.yml file
  # created with you own credentials
  Builder.new q
end
