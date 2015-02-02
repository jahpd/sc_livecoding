require 'soundcloud'
require 'yaml'
require 'ruby-progressbar'
require "#{File.dirname(__FILE__)}/searchs"

module Processor

  module SC
    YAML_BASE = "---\n"
    
    attr_accessor :client_soundcloud

    def init_soundcloud
      path = "#{File.dirname(__FILE__)}/soundcloud.yml"
      yaml = YAML.load_file path
      
      @client_soundcloud = Soundcloud.new(:client_id => yaml["client_id"], :client_secret => yaml["client_secret"])
      @total = 0
    end
    
    def _tracks(q, offset, &block) 
      begin
        _tracks = @client_soundcloud.get('/tracks', :q => q, :limit => 200, :offset => offset, :linked_partitioning => 1).response
        if block
          yield _tracks
        else
          _tracks
        end
       rescue Soundcloud::ResponseError => e
        puts "#{e.message}, Status Code: #{e.response.code}"
        puts "Trying again "
        if block
          yield @client_soundcloud.get('/tracks', :q => q, :limit => 200, :offset => offset, :linked_partitioning => 1).response
        end
      end
    end

    # The processor for Soundcloud Client
    def sc_process_tracks(tracks, q)
      s = ""
      l = tracks["collection"].length
      pb = ProgressBar.create(:title => "Downloading", :starting_at => 0, :total => l)
      
      @total += tracks["collection"].length

      tracks["collection"].each do |obj|
        # Overrided method
        s << select_soundcloud_keys(obj)
        pb.increment
      end
      if tracks["next_href"]
        # now get the value of offset
        puts "-------------\nfound some anothers tracks\n-------------"
        puts tracks["next_href"]
        offset = tracks["next_href"].scan /offset=[0-9]+/
        offset = offset[0].scan /[0-9]+/
        offset = offset[0].to_i
        _tracks(q, offset) do |_tracks|
          s << sc_process_tracks(_tracks, q)
        end
      end
      
      s
    end
    
    def select_soundcloud_keys(obj)
      s = ""
      obj.each_pair{|k, v|
        if(k == "id")
          s << "#{v}:\n"
          
        elsif(k=="user")
          info = get_user_infos(v["id"])
          country = info["country"] ? info["country"] : "Not provided"
          gsub_me(country)
          city = info["city"] ? info["city"] : "Not provided"
          gsub_me(city)
          s << "  country: \"#{country}\"\n"
          s << "  city: \"#{city}\"\n"
        end

        Client::SoundcloudSearch::STATS.each {|e|
          if(k == e)
            gsub_me(v)
            s << "  #{k}: \"#{v ? v: "Not provided"}\"\n"
          end
        }
      }
      s
    end

    def get_user_infos(id)
      @client_soundcloud.get("/users/#{id}").response
    end

    def gsub_me(v)
       if(/\"[\w\S\s]+\"/ =~ v)
         v.gsub!(/\"[\w\S\s]+\"/){|p| "\\\"#{p[1..p.length-2]}\\\""}
       end
    end

  end
end
