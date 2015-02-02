require "#{File.dirname(__FILE__)}/soundcloudclient_process"

# find all sounds of buskers licensed under 'creative commons share
# alike

module Client

  # Our credentials

  class Soundcloud
    
    include Processor::SC

    # create a client object with your app credentials
    def initialize
      init_soundcloud
    end

    # get /tracks mount point with single question
    # <code>
    # sc = Client::Soundcloud.new
    
    # sc.tracks(q)
    # </code>
    def tracks(q)
      puts "-------------\nsearching for #{q}\nwith maximum 200 items per pagination\n-------------"
      string = YAML_BASE
      #Soundcloud API gets a limit
      # we need add some param to get next_href
      # so we will get all tracks
      @total = 0   
      _tracks(q, 0) do |tracks|
        string << sc_process_tracks(tracks, q)
        puts "Found #{@total} tracks"

        q.gsub!(/\ /, "_")
        File.open("main/soundcloud_#{q}.yml", "w"){|f|   
          f.write string
          f.close()
        }

        
        File.open("main/total_soundcloud_#{q}.yml", "w"){|f| 
          f.write "total: #{@total}"
          f.close()
        }
      end
      
      # reset total
      @total = 0
    end
  end
end
