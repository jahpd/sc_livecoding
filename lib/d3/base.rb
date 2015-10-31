require "yaml"
require 'mongo'
require 'mongo/driver'


module D3

  module Base
    
    include Mongo

    def sanitize(input)
      input.gsub!(/\ /, "_")
    end

    def search_value_for(obj, keyparam, &block)
      obj.each{|k, v|
        if(k == keyparam)
          v = k == "created_at" ? v[0..3] : v
          yield v
        end
      }
    end

    def load_collection(client, query)
      connection = Mongo::Connection.new
      db = connection[client]
      collection = db[query]
      Mongo.defaults[:convert_underscore_to_dollar] = true
      yield collection
    end


  end
 
  
end

###
#Transform childrens
#      build_treemap_for yaml, keyparams do |name, value|
#        if(name == "created_at")
#          value = value[0..3]
#        end
#        unless keys[:children].include? value
#          keys[:children] << value 
#        end
#      end

#      keys[:children] = keys[:children].map{|obj|
#        h = {:name => obj[:name], :children => obj.map{|k, v|
#          unless(k == :name)
#            {:name => k, :size => v}
#          end
#        }}
#        h[:children].shift
#        h
#     }
###

