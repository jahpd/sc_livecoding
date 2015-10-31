module Client
  
  module Script

    module CirclePacking

      def zoomable_circle_packing_css
        """.node {
  cursor: pointer;
}

.node:hover {
  stroke: #000;
  stroke-width: 1.5px;
}

.node--leaf {
  fill: white;
}

.label {
  font: 11px 'Helvetica Neue', Helvetica, Arial, sans-serif;
  text-anchor: middle;
  text-shadow: 0 1px 0 #fff, 1px 0 0 #fff, -1px 0 0 #fff, 0 -1px 0 #fff;
}

.label,
.node--root,
.node--leaf {
  pointer-events: none;
}

"""
      end

      def zoomable_circle_packing(filename)
        puts "=> Generating #{filename}.js"
        script = """var margin = 20,
    diameter = 640;

var color = d3.scale.linear()
    .domain([-1, 5])
    .range(['hsl(152,80%,80%)', 'hsl(228,30%,40%)'])
    .interpolate(d3.interpolateHcl);

var pack = d3.layout.pack()
    .padding(2)
    .size([diameter - margin, diameter - margin])
    .value(function(d) { return d.value; })

var svg = d3.select('body').append('svg')
    .attr('width', diameter)
    .attr('height', diameter)
  .append('g')
    .attr('transform', 'translate(' + diameter / 2 + ',' + diameter / 2 + ')');

d3.json('/stats/#{filename}.json', function(error, root) {
  if (error) return console.error(error);

  var focus = root,
      nodes = pack.nodes(root),
      view;

  var circle = svg.selectAll('circle')
      .data(nodes)
    .enter().append('circle')
      .attr('class', function(d) { return d.parent ? d.children ? 'node' : 'node node--leaf' : 'node node--root'; })
      .style('fill', function(d) { return d.children ? color(d.depth) : null; })
      .on('click', function(d) { if (focus !== d) zoom(d), d3.event.stopPropagation(); });

  var text = svg.selectAll('text')
      .data(nodes)
    .enter().append('text')
      .attr('class', 'label')
      .style('fill-opacity', function(d) { return d.parent === root ? 1 : 0; })
      .style('display', function(d) { return d.parent === root ? null : 'none'; })
      .text(function(d) { return d.name; });

  var node = svg.selectAll('circle,text');

  d3.select('body')
      .style('background', color(-1))
      .on('click', function() { zoom(root); });

  zoomTo([root.x, root.y, root.r * 2 + margin]);

  function zoom(d) {
    var focus0 = focus; focus = d;

    var transition = d3.transition()
        .duration(d3.event.altKey ? 7500 : 750)
        .tween('zoom', function(d) {
          var i = d3.interpolateZoom(view, [focus.x, focus.y, focus.r * 2 + margin]);
          return function(t) { zoomTo(i(t)); };
        });

    transition.selectAll('text')
      .filter(function(d) { return d.parent === focus || this.style.display === 'inline'; })
        .style('fill-opacity', function(d) { return d.parent === focus ? 1 : 0; })
        .each('start', function(d) { if (d.parent === focus) this.style.display = 'inline'; })
        .each('end', function(d) { if (d.parent !== focus) this.style.display = 'none'; });
  }

  function zoomTo(v) {
    var k = diameter / v[2]; view = v;
    node.attr('transform', function(d) { return 'translate(' + (d.x - v[0]) * k + ',' + (d.y - v[1]) * k + ')'; });
    circle.attr('r', function(d) { return d.r * k; });
  }
});

d3.select(self.frameElement).style('height', diameter + 'px');"""
      end

      def circle_packing_css
        """circle {
  fill: rgb(31, 119, 180);
  fill-opacity: .25;
  stroke: rgb(31, 119, 180);
  stroke-width: 1px;
}

.leaf circle {
  fill: #ff7f0e;
  fill-opacity: 1;
}

text {
  font: 10px sans-serif;
}"""
      end

      def circle_packing(filename, opt={:diameter => 920})
        script = """diameter = #{opt[:diameter]}
format = d3.format(',d')
pack = d3.layout.pack()
    .size([diameter - 4, diameter - 4])
    .value((d) -> d.value)

svg = d3.select('body')
    .append('svg')
    .attr('width', diameter)
    .attr('height', diameter)
    .append('g')
    .attr('transform', 'translate(2,2)')

d3.json '/stats/#{filename}.json', (error, root) ->

  node = svg.datum(root)
      .selectAll('.node')
      .data(pack.nodes)
      .enter()
      .append('g')
      .attr('class', (d) -> d.children ? 'node' : 'leaf node')
      .attr('transform', (d) -> \"translate(\#{d.x},\#{d.y})\")

  _text = (d) -> 
    sufix = if d.children then '' else \": \#{format(d.value)}\"
    \"\#{d.name}\#{sufix}\"

  node.append('title')
      .text(_text)

  node.append('circle').attr('r', (d) -> d.r)

  node.filter((d) -> !d.children)
      .append('text')
      .attr('dy', '.3em')
      .style('text-anchor', 'middle')
      .text((d) -> d.name.substring(0, d.r/3))

d3.select(self.frameElement).style('height', \"\#{diameter}px\")"""

        compile filename, script
       
      end
    end
  
  end
end