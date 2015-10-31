require 'ruby-progressbar'
require "#{File.dirname(__FILE__)}/db"
require "#{File.dirname(__FILE__)}/../searchs"

module Client

  class SC
   
    include Client::Database::SC

    WORDS = %w[created_at genre license title user_id]
    USER_WORDS = %w[country city]

    # create a client object with your app credentials
    def initialize
      init
    end

    # get /tracks mount point with single question
    # <code>
    # sc = Client::Soundcloud.new 
    # sc.tracks(q)
    # </code>
    def tracks(query)
      s = "\nsearching for #{query}\nwith maximum 200 items per pagination\n"
      pre = ""
      s.split("\n")[2].length.times{|i| pre << "**"}
      puts "#{pre}#{s}#{pre}"
      #Soundcloud API gets a limit
      # we need add some param to get next_href
      # so we will get all tracks
      #@total = 0   
      get_tracks(query) do |collection, track| 
        filter_and_add_to collection, track
      end

    end

    def filter_and_add_to(collection, track)
      document = track.reject {|k, v| !WORDS.include? k}
      document["created_at"] = {:year => document["created_at"][0..3], :month => document["created_at"][5..6]}
      
      infos = get_user_infos(track["user_id"])
      infos = infos.reject{|k, v| !USER_WORDS.include? k}
      infos.each{|k, v| document[k] = v=="" || v==nil ? "unknown" : v}
      
      collection.save document
    end

  end
end
