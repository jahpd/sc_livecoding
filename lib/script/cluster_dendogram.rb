module Client
  
  module Script

    module ClusterDendogram

      def cluster_dendogram_css
        """.node circle {
  fill: #fff;
  stroke: steelblue;
  stroke-width: 1.5px;
}

.node {
  font: 10px sans-serif;
}

.link {
  fill: none;
  stroke: #ccc;
  stroke-width: 1.5px;
}"""
      end

      def cluster_dendogram(filename, opt={:radius => 960})
        p = "#{filename}.json"
        script = """radius = #{opt[:radius]} / 2;

cluster = d3.layout.cluster().size([360, radius - 120]);

diagonal = d3.svg.diagonal.radial()
    .projection((d) ->  [d.y, d.x / 180 * Math.PI]);

svg = d3.select('body').append('svg')
    .attr('width', radius * 2)
    .attr('height', radius * 2)
    .append('g')
    .attr('transform', 'translate(' + radius + ',' + radius + ')');

d3.json '#{p}', (error, root) ->
   nodes = cluster.nodes(root);

   link = svg.selectAll('path.link')
      .data(cluster.links(nodes))
      .enter().append('path')
      .attr('class', 'link')
      .attr('d', diagonal);

   node = svg.selectAll('g.node')
      .data(nodes)
    .enter().append('g')
      .attr('class', 'node')
      .attr('transform', (d) ->  'rotate(' + (d.x - 90) + ')translate(' + d.y + ')')

  node.append('circle')
      .attr('r', 4.5);

  node.append('text')
      .attr('dy', '.31em')
      .attr('text-anchor', (d) ->  if d.x < 180 then 'start' else 'end')
      .attr('transform', (d) ->  if d.x < 180 then  'translate(8)' else 'rotate(180)translate(-8)')
      .text((d) ->  d.name);

d3.select(self.frameElement).style('height', radius * 2 + 'px');"""

        compile filename, script
       
      end
    end
  
  end
end
