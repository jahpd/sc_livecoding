require "#{File.dirname(__FILE__)}/soundcloudclient"
require "#{File.dirname(__FILE__)}/searchs"

# Initialize our client
# needs some soundcloud.yml file
# created with you own credentials
soundcloud = Client::Soundcloud.new

# This can be everything you want
# for our research we target the 
# following words:
# "livecoding", "live-coding", 
# "webpot", "webaudioapi"
include Client::SoundcloudSearch

# Now search
SEARCHS.each do |e|
  soundcloud.tracks(e)
end
