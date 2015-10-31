module D3

  module Histogram

    def histogram(hash, key)
      
      _key = key == "" || key == nil ? "unknown": key.downcase 
      
      unless hash[_key]
        hash[_key] = 1
      else
        hash[_key] += 1
      end
      hash
    end

    def contributors(value)
      unless(value.instance_of? Fixnum)
        value.each{|kkk, vvv|
          loc = vvv["location"]
          loc2 = nil
          if(/[a-zA-Z]+,\ [a-zA-Z]+/ =~ loc)
            loc = loc.split(",")[0]
            loc2 = loc.split(",")[1] 
          end
          histogram(keys, loc)
          histogram(keys, loc2) if loc2
        }
      else
        histogram(keys, "Not provided")
      end
    end
  end



end
