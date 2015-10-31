module Client

  module Script
    
    module Sunburst
      
      def sunburst_css
        """body {
font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
  margin: auto;
  position: relative;
  width: 960px;
}

form {
  position: absolute;
  right: 100px;
  top: 100px;
}"""
      end

      def sunburst(filename, opt={:width => 960, :height => 700})
        puts "=> Generating #{filename}"
        script = """
$(document).ready(function(){
  var $form = $('<form/>')
  var $label = $('<label/>') 
  var $a = $('<input type=\"radio\" name=\"mode\" value=\"size\">Size</input>')
  var $b = $('<input type=\"radio\" name=\"mode\" value=\"count\" checked> Count</input>')
  $label.append($a).append($b).appendTo($form)
  $form.appendTo('body')
})
var width = #{opt[:width]},
    height = #{opt[:height]},
    radius = Math.min(width, height) / 2,
    color = d3.scale.category20c();

var svg = d3.select('body').append('svg')
    .attr('width', width)
    .attr('height', height)
  .append('g')
    .attr('transform', 'translate(' + width / 2 + ',' + height * .52 + ')');

var partition = d3.layout.partition()
    .sort(null)
    .size([2 * Math.PI, radius * radius])
    .value(function(d) { return 1; });

var arc = d3.svg.arc()
    .startAngle(function(d) { return d.x; })
    .endAngle(function(d) { return d.x + d.dx; })
    .innerRadius(function(d) { return Math.sqrt(d.y); })
    .outerRadius(function(d) { return Math.sqrt(d.y + d.dy); });

d3.json('/stats/#{filename}.json', function(error, root) {
  var path = svg.datum(root).selectAll('path')
    .data(partition.value(function(d) { 
      return d.value
    }).nodes)
    .enter().append('path')
    .attr('display', function(d) { return d.depth ? null : 'none'; }) // hide inner ring
    .attr('d', arc)
    .style('stroke', '#fff')
    .style('fill', function(d) { return color((d.children ? d : d.parent).name); })
    .style('fill-rule', 'evenodd')
    .append('text')
    .text(function(d){
      d.name
    })
    //.each(stash);

});

// Stash the old values for transition.
function stash(d) {
  d.x0 = d.x;
  d.dx0 = d.dx;
}

// Interpolate the arcs in data space.
function arcTween(a) {
  var i = d3.interpolate({x: a.x0, dx: a.dx0}, a);
  return function(t) {
    var b = i(t);
    a.x0 = b.x;
    a.dx0 = b.dx;
    return arc(b);
  };
}

d3.select(self.frameElement).style('height', height + 'px');
"""
      end
    end
    
  end
  
end
