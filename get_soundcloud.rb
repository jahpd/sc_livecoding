require "#{File.dirname(__FILE__)}/lib/soundcloud/client"
require "#{File.dirname(__FILE__)}/lib/searchs"

# Initialize our client
# needs some soundcloud.yml file
# created with you own credentials
soundcloud = Client::SC.new

# This can be everything you want
# for our research we target the 
# following words:
# "livecoding", "live-coding", 
# "webpot", "webaudioapi"
Client::SoundcloudSearch::SEARCHS.each do |e|
  soundcloud.tracks(e)
end
