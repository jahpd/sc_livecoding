require 'coffee-script'
require 'fileutils'

# https://github.com/mbostock/d3/wiki/Gallery
module Client

  module Script

    def create(input, type, opt)
      if(/\ / =~ input)
        input.gsub!(/\ /, "_") 
      end

      input = "#{opt[:client]}_#{input}" if opt[:client]

      total = YAML.load_file("main/total_#{input}.yml")["total"]

      script = """d3.tsv \"/stats/#{input}_#{type}.tsv\", (error, data) ->
  for d in data
    d.value = parseFloat d.value
  obj = 
    header:
      title:
        text: '#{type} distribuition of #{total} works published on #{opt[:client]}'
        fontSize: 24
        font: 'open sans'
      subtitle:
        text: 'Distribuition of tag #{input}'
        color: '#999999'
        fontSize: 12
        font: 'open sans'
      titleSubtitlePadding: 9
    footer:
      color: '#999999'
      fontSize: 10
      font: 'open sans'
      location: 'bottom-left'
    size:
      canvasWidth: 512 + 128
      canvasHeight: 512 + 128
      pieOuterRadius: \"74%\"
    data:
      sortOrder: 'value-desc'
      content: data
    labels:
      outer:
        pieDistance: 32
      inner:
        hideWhenLessThanPercentage:3
      mainLabel:
        fontSize: 11
      percentage:
        color: '#ffffff'
        decimalPlaces: 2
      value:
        color: '#adadad'
        fontSize: 11
      lines: 
        enabled: true		
    effects:
      pullOutSegmentOnClick: 
        effect: 'linear'
        speed: 400
        size: 8
    misc:
      gradient:
        enabled: true
        percentage: 100

  window.pie = new d3pie 'pieChart', obj
"""

      path = "/tmp/#{input}_#{type}.coffee"
      
      File.open(path, "w+") do |f|
        puts "Generating #{path}"
        f.write script
        f.close()
      end
      
      js = CoffeeScript.compile(File.read(path), :bare => true)
      delete path, "coffee"
      js
    end
    
    
    def delete(filename, ext)
      Dir["#{File.dirname(filename)}/*.#{ext}"].each do |file|
        next if File.basename(file) == File.basename(filename)
        FileUtils.rm_rf file, :noop => true, :verbose => true
      end
    end
  end

end





