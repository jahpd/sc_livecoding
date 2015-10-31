module Client
  
  module Script

    module TreemapPadding

      def treemap_padding_css
        """body {
  font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
  margin: auto;
  position: relative;
  width: 960px;
}

form {
  position: absolute;
  right: 10px;
  top: 10px;
}

.node {
  border: solid 1px white;
  font: 10px sans-serif;
  line-height: 12px;
  overflow: hidden;
  position: absolute;
  text-indent: 2px;
}

"""
      end

      def treemap_padding(filename, opt={:width => 960, :height => 500})
        script = """
margin = top: 40, right: 10, bottom: 10, left: 10

width = #{opt[:width]} - margin.left - margin.right
height = #{opt[:height]} - margin.top - margin.bottom

color = d3.scale.category20c()

treemap = d3.layout.treemap()
    .size([width, height])
    .sticky(true)
    .value((d) -> d.value)

div = d3.select('body').append('div')
    .style('position', 'relative')
    .style('width', (width + margin.left + margin.right) + 'px')
    .style('height', (height + margin.top + margin.bottom) + 'px')
    .style('left', margin.left + 'px')
    .style('top', margin.top + 'px');

position = ->
  this.style('left', (d) -> d.x + 'px')
      .style('top', (d) -> d.y + 'px')
      .style('width', (d) -> Math.max(0, d.dx - 1) + 'px')
      .style('height', (d) -> Math.max(0, d.dy - 1) + 'px');

d3.json '/stats/#{filename}.json', (error, root) ->
  nodes = treemap.nodes(root)
  div.selectAll('.node')
      .data(nodes)
      .enter().append('div')
      .attr('class', 'node')
      .style('left', (d) -> d.x + 'px')
      .style('top', (d) -> d.y + 'px')
      .style('width', (d) -> Math.max(0, d.dx - 1) + 'px')
      .style('height', (d) -> Math.max(0, d.dy - 1) + 'px')
      .style('background', (d) -> if d.children then color(d.name) else null)
      .text((d) -> if d.children then null else d.name) #if d.children then null else d.name);
"""

        compile filename, script
       
      end
    end
  
  end
end
