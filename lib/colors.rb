module Client

  module Colors

    COLOR = [0,1,2,3,4,5,6,7,8,9,'A','B','C','D','E','F']

    def create_color
      c = ""
      6.times{|i| c << "#{COLOR[Random.rand(COLOR.length)]}" }
      "\##{c}"
    end
    
  end

end
