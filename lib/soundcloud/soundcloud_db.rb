require 'soundcloud'
require 'yaml'
require 'mongo'

module Client

  module Database

    module Soundcloud

    #YAML_BASE = "---\n"
    
      include Mongo
      attr_accessor :client_soundcloud
      
      def init_soundcloud(path)
        yaml = YAML.load_file path
        @client_soundcloud = Soundcloud.new(:client_id => yaml["client_id"], :client_secret => yaml["client_secret"])
        db = MongoClient.new("localhost", 27017).db("livecoding")
        @collection = db.collection("soundcloud")
        
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
      
      def filter_and_add_to_db(obj, filters)
        obj.each_pair{|k, v|
          puts "#{k}: #{v}"
          document = Hash.new
          if(k == "id")
            id = v["id"]
            document[:_id] = id
          elsif(k=="user")
            puts v
            filters.each do |e|
              if(k == e)
                document[id][k] = info[v] != "" ? gsub_me(info[v]) : "unknown" 
              end
            end
          end
          
          @collection.insert(document)
        }      
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
