require "yaml"

module Statistics
  
  module TSV
    
    COLOR = [0,1,2,3,4,5,6,7,8,9,'A','B','C','D','E','F']

    def _histogram(hash, key)
      unless hash[key]      
        hash[key] = 1
      else
        hash[key] = hash[key] + 1
      end
    end
    
    def gen_for(input, key, opt)
      input.gsub!(/\ /, "_")
      input = "#{opt[:client]}_#{input}" if opt[:client]
      puts "********************************************\n#{key} stats for #{input}\n********************************************"
      yaml = YAML.load_file "main/#{input}.yml"
      keys = Hash.new
      
      yaml.each_pair{|k, v|
        v.each{|kk, vv|
          if(kk == key)
            if(kk == "created_at")
              vv = vv[0..3]
              _histogram(keys, vv)
            elsif(kk == "contributors")
              unless(vv.instance_of? Fixnum)
                vv.each{|kkk, vvv|
                  loc = vvv["location"]
                  loc2 = nil
                  if(/[a-zA-Z]+,\ [a-zA-Z]+/ =~ loc)
                    loc = loc.split(",")[0]
                    loc2 = loc.split(",")[1] 
                  end
                  _histogram(keys, loc)
                  _histogram(keys, loc2) if loc2
                }
              else
                _histogram(keys, "Not provided")
              end
            else
              _histogram(keys, vv)
            end
          end
        }
      }

      p = "main/total_#{input}.yml"
      yml = YAML.load_file p
      total = yml["total"]

      if(/\ / =~ input)
        input.gsub!(/\ /, "_") 
      end

      tsv = "public/stats/#{input}_#{key}.tsv"
      File.open(tsv, "w+") do |f|
        puts "Generating #{tsv}"
        string = "label\tvalue\tcolor\n"
        keys.each_pair{|k, v|
          c = "#"
          6.times{|i| c<< "#{COLOR[Random.rand(COLOR.length)]}" }
          unless(k=="total")
            t = v.to_f/total
            string <<  "#{k}\t#{t}\t#{c}\n"
          end
        }
 
        f.write string
        f.close()
      end
    end

  end
  
end
