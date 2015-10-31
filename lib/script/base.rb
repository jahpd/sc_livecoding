require 'coffee-script'

module Client
  
  module Script

    module Base

      def sanitize(input)
        if(/\ / =~ input)
          input.gsub!(/\ /, "_") 
        end
      end
      
      def compile(filename, script)
      
        path = "/tmp/#{filename}"
        ext = "coffee"
        
        File.open("#{path}.#{ext}", "w+") do |f|
          puts " => Generating #{path}.#{ext}"
          f.write script
          f.close()
        end
        
        js = CoffeeScript.compile(File.read("#{path}.#{ext}"), :bare => true)
        #delete path, ext
        js
      end
      
      private
      
      def delete(filename, ext)
        Dir["#{File.dirname(filename)}/*.#{ext}"].each do |file|
          next if File.basename(file) == File.basename(filename)
          FileUtils.rm_rf file, :noop => true, :verbose => true
        end
      end
      
    end
  end
end
