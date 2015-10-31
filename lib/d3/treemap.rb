require "#{File.dirname(__FILE__)}/tree"

module D3

  module Treemap
    
    # Receives a tree map with specified names
    # example: 
    # <code>
    # build_treemap "some_key", ["created_at", ["genre", "license"]]
    # </code>
    # will return a hash like
    #{
    # name: "some_key"
    # children: [
    #   {name: "some_another_key", children: [
    #     ...
    #   ]}
    #   ...
    # ]
    #}
    # return Hash
    def build_treemap(name, projected, filters, &block)
      #Create a new tree 
      
      yield a = projected.map{|p|
        p.reject{|k| !filters.include?(filters[0])}
      }
    end

  end
end

        # Get the first key one time
        # build a hash
        #keys2 = search_values_one_time obj, tree, key2
        
        #adapt second level
        #tree.children.map!{|current_key|
        #  t = tree.add_tree current
        #  t.add_node

        #  arrays_of_compares = []
        #  obj.each{|id, v|
        #    # compare keys
           
        #    v[key1] = key1 == "created_at" ? v[key1][0..3] : v[key1]
        #    if(v[key1] == current_key)
        #      histogram hash, v[key2]
        #    end
        
        #build_hash_from_compare obj, hash, current_key, key1, key2

        #  t.children = hash.map{|k, v| 
        #    h = {:name => k, :value => v}
        #  }
          
        #  t.to_hash
        #}
       
        #yield tree.to_hash
        #tree.to_hash
        #end

