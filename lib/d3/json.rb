require "json"
require 'histogram/array'

module D3
  
  module JSON

    #MONTHS = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Nov", "Dez"]
    #YEARS = [2000..2015].map{|e| e.to_s}
    #N_MONTHS = [1..12].map{|i| (i < 10) ? "0#{i}" : i.to_s }
    
    def path(client, query)
      path = File.dirname(__FILE__)
     
      p = "#{client}_#{query}"

      path = File.expand_path "#{path}/../../public/stats/#{p}.json"
      yield p, path
    end

    def histogram_collection(collection, key)
      children = Hash.new
      collection.all do |doc|
        if(key == "year" || key == "month")
          histogram children, doc["created_at"][key]
        else
          histogram children, doc[key]
        end
      end
      children
    end

    def treemap(collection, key, key2)
      _children = histogram_collection(collection, key)
      _children = _children.map{|k, v|    
        _f = key == "year" || key == "month" ? "created_at.#{key}": key
        filter = {"#{_f}" => {:_in => [k]}}
        c = Hash.new
        collection.all filter do |f|
          histogram c, f[key2]
        end
        c = c.map{|kk, vv|{:name =>kk, :value => vv}}
        {:name =>k, :children => c}
      }
      _children
    end


    def treemap_json(client, query, key1, key2)
      c = load_collection client, query do |collection|
        treemap(collection, key1, key2)
      end
      h = {:name => "#{client}_#{query}", :children => c}
      p = File.dirname(__FILE__)
      filename = "#{client}_#{query}_#{key1}_#{key2}"
      pp = "../../public/stats/#{filename}.json"
      p = File.join(p, pp)
      p = File.expand_path(p)
      puts "=> Genreating #{p}"
      File.open(p, "w+") do |f|
        f.write h.to_json
        f.close()
      end
      filename
    end
  end
end
