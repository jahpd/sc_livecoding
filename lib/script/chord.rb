require "#{File.dirname(__FILE__)}/colors"

module Client
  
  module Script

    module Chord

      include Client::Colors

      def create_chord(inputs, type, opt)
        sanitize(input, opt) for input in inputs

        datas = makeInputs(inputs, type)
        colors = create_colors(inputs)
        
        script = """matrix = []

#{datas}

svg = d3.select('body').append('svg')
  .attr('width', width)
  .attr('height', height)
  .append('g')
  .attr('transform', 'translate(\#{width / 2}, \#{height / 2})')

range_colors = #{colors}

width = #{opt[:width]}
height = #{opt[:height]}

innerRadius = Math.min(width, height) * .41
outerRadius = innerRadius * 1.1

fill = d3.scale.ordinal()
  .domain(d3.range(range_colors.length))
  .range(range_colors)

chord = d3.layout.chord()
  .padding(.05)
  .sortSubgroups(d3.descending)
  .matrix(matrix);

fillme = (d) -> fill(d.index)

svg.append('g')
  .selectAll('path')
  .data(chord.groups)
  .enter().append('path')
  .style('fill, filme)
  .style('stroke', filme)
  .attr('d', d3.svg.arc().innerRadius(innerRadius).outerRadius(outerRadius))
  .on('mouseover', fade(.1))
  .on('mouseout', fade(1))
"""

        compile input, type, script
       
      end

      def makeInputs(inputs, type)
        s = ""
        inputs.each do |i|
          s << """data.tsv #{i}, (error, data) ->
  column = v for k, v in data when k is '#{type}'
  matrix.push column
"""
        end
        s
      end

    end
  
  end
end
