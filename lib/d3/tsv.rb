require "yaml"
require "#{File.dirname(__FILE__)}/base"

module Statistics
  
  module TSV
    
    def header(obj)
      s = "labels\t"
      i = 0
      obj.each{|k, v|
        s << "#{k}\t" if i < obj.length-1
        s << "#{k}\n" if i == obj.length-1
        i += 1
      }
      s
    end

    def value_headers(obj)
      s = ""
      obj.each_pair{|k, v|
        v.each_pair{|kk, vv|
          s << "#{kk}\n" 
        }
      }
      s
    end

    def values(s, obj)
      i = 0
      s.each_line{|line|
        unless(i==0)
          obj.each_pair{|k, v|
            j = 0
            v.each_pair{|kk, vv|
              line << "#{vv}\t" if(j<v.length-1)
              line << "#{vv}\n" if(j==v.length-1)
              j += 1
            }
          }
        end
      }
    end

    def tabular_tsv(input, key1, key2)
      tabular_for(input, key1, key2, "tsv") do |obj, path|
        s = header obj
        s << value_headers(obj)
        values s, obj
        
        puts s
        #File.open(path, "w+") do |f|
        #  puts "Generating #{path}"
        #  f.write s
        #  f.close()
        #end
      end
      
    end


  end
  
end
