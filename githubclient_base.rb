module Client

  module GithubSearch

    module Methods
    
      def init_client
        yaml = YAML.load_file "#{File.dirname(__FILE__)}/github.yml"
        # Fetch the current user
        
        @client = Octokit::Client.new(:login => yaml["login"], :password => yaml["password"])
        yaml = nil
        true
      end

      def def_key(resource, key)
        unless(resource[key].nil? or resource[key] == "")
          k = resource[key]
        else
          k = "Not provided"
        end
      end
      
      # every contribution have a location
      def process_contributions(string, repo)
        string << "  contributors:"

        contribs = @client.contribs(repo)
        if(contribs.length > 0)
          string << "\n"
          contribs.each{|c|
            # users can be identified or can be anonymous
            users = @client.legacy_search_users(c.login)
            users.each{|u|
              if(u.login == c.login)
                string << "    #{u.login}:\n"
                loc = def_key(u, "location")
                string << "      location: \"#{loc}\"\n"
              end
            }
          }
        else
          string << " 0\n"
        end
      end
        
      def process_basic_info(string, resource)
        string << "\"#{resource.owner}/#{resource.name}\":\n"
        string << "  created_at: #{resource.created_at}\n"
        
        lang = def_key(resource, "language")
        string << "  language: #{lang}\n"
      end
    end
  end
end
