require 'mongo'
require 'soundcloud'
require 'yaml'
require 'mongo/driver'

module Client

  module Database

    module SC
      
      include Mongo
    #YAML_BASE = "---\n"
    
      #attr_accessor :client_soundcloud
       
      DB_NAME = "soundcloud"

      def init
        yaml = YAML.load_file "./soundcloud.yml"
        @client_soundcloud = Soundcloud.new(client_id: yaml["client_id"], client_secret: yaml["client_secret"])
        @db =  Mongo::Connection.new
      end

      def ask(msg,  &block)
        puts "!!! #{msg}"
        answer = gets.chomp
        yield answer
      end

      def save(query, tracks, &block)
        q = query.gsub(/\ /, "_")
        
        tracks["collection"].each do |track|
          yield @db[q], track
        end
      end
      
      def track_me(tracks, opt, first, &block)
        l = tracks["collection"].length
        pb = ProgressBar.create(:title => "Downloading ", :starting_at => 0, :total => l)

        if first
          ask "you want overwrite? (y/n)" do |a|
            if a == "y"
              save opt[:q], tracks do |mongo_collection, track|
                yield mongo_collection, track
                pb.increment
              end
            else
              puts "=> Skipping"
            end
          end
        else
          save opt[:q], tracks do |mongo_collection, track|
            yield mongo_collection, track
            pb.increment
          end
        end
      end

      def query_tracks(opt)
        tracks = @client_soundcloud.get('/tracks', opt).response
        # For every collection, add a progress and yield result
        
        track_me(tracks, opt, opt[:offset]==0){ |collection, track|
          yield collection, track
        }
        
        #recursively get new tracks offset
        if tracks["next_href"]
          # now get the value of offset
          puts "=> found some anothers tracks"
          puts tracks["next_href"]
          offset = tracks["next_href"].scan /offset=[0-9]+/
          offset = offset[0].scan /[0-9]+/
          opt = {:q => opt[:q], :limit => 200, :offset =>  offset[0].to_i, :linked_partitioning => 1}
          query_tracks(opt) do |collection, track|
            yield collection, track
          end
        end
      end
      
      def get_tracks(query, &block) 
        opt = {:q => query, :limit => 200, :offset => 0, :linked_partitioning => 1}
        begin
          # Get tracks  
          query_tracks(opt) do |collection, track|
            yield collection, track
          end
        rescue Soundcloud::ResponseError => e
          puts "=> #{e.message}, Status Code: #{e.response.code}"
          puts "=> Trying again "
          query_tracks(opt) do |collection, track|
            yield collection, track
          end
        end
      end

      def get_user_infos(id)
        @client_soundcloud.get("/users/#{id}").response
      end
      
      def gsub_me(v)
        if(/\"[\w\S\s]+\"/ =~ v)
          v.gsub!(/\"[\w\S\s]+\"/){|p| "\\\"#{p[1..p.length-2]}\\\""}
        end
      end
      
      #def select_soundcloud_keys(obj)
      #  s = ""
      #  obj.each_pair{|k, v|
      #    if(k == "id")
      #      s << "#{v}:\n"
      #      
      #    elsif(k=="user")
      #      info = get_user_infos(v["id"])
      #      country = info["country"] ? info["country"] : "Not provided"
    #      gsub_me(country)
      #      city = info["city"] ? info["city"] : "Not provided"
      #      gsub_me(city)
      #      s << "  country: \"#{country}\"\n"
      #      s << "  city: \"#{city}\"\n"
      #    end
      
      #    Client::SoundcloudSearch::STATS.each {|e|
      #      if(k == e)
      #        gsub_me(v)
    #        s << "  #{k}: \"#{v ? v: "Not provided"}\"\n"
      #      end
      #    }
      #  }
      #  s
      #end
    end
  end
end
