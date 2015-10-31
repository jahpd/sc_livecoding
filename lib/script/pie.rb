module Client
  
  module Script

    module Pie

      def create_pie(input, type, opt)
        sanitize input, opt
        
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
        compile input, type, script
      end

    end
  
  end
end
