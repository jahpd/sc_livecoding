module Client

  module Script

    module Streamgraph

      def streamgraph_css
        """body {
  font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
  margin: auto;
  position: relative;
  width: 960px;
}

button {
  position: absolute;
  right: 10px;
  top: 10px;
}"""
      end
  
      def streamgraph(filename)
        script = """
d3.json('/stats/#{filename}.json', function(error, root){
  var n = root.children.length // number of layers
  var m = 0 // number of samples per layer
  var matrix = []
  root.children.forEach(function(obj){
    if(obj['children'].length > m) m = obj['children'].length
    var col = []
    obj['children'].forEach(function(obj){
      col.push(obj['value']);
    })
    matrix.push(col);
  });

  matrix.forEach(function(row){
    var dm = m - row.length
    if(dm > 0){
      for(var i=0; i<dm; i++){
        row.push(0);
      }
    }
    
  })
  
  var stack = d3.layout.stack().offset('wiggle')
  var layers0 = stack(matrix.map(function(r) { return bumpLayer(r); }));
  var layers1 = stack(matrix.map(function(r) { return bumpLayer(r); }));

  var width = 960,
    height = 500;

  var x = d3.scale.linear()
    .domain([0, m - 1])
    .range([0, width]);

  var y = d3.scale.linear()
    .domain([0, d3.max(layers0.concat(layers1), function(layer) { return d3.max(layer, function(d) { return d.y0 + d.y; }); })])
    .range([height, 0]);

  var _colors = layers0[0].map(function(e){
    var s = '#'
    var a = ['a', 'b', 'c', 'd', 'e', 2, 3, 4, 5] 
    for(i=0;i<3;i++){
      s += a[Math.floor(Math.random() * a.length)]
    }
    return s
  });
  
  var color = d3.scale.category20c()
    .range(_colors);

  var area = d3.svg.area()
    .x(function(d) { return x(d.x); })
    .y0(function(d) { return y(d.y0); })
    .y1(function(d) { return y(d.y0 + d.y); });

  var svg = d3.select('body').append('svg')
    .attr('width', width)
    .attr('height', height);

  svg.selectAll('path')
    .data(layers0)
  .enter().append('path')
    .attr('d', area)
    .style('fill', function() { return color(Math.random()); });
})

function transition() {
  d3.selectAll('path')
      .data(function() {
        var d = layers1;
        layers1 = layers0;
        return layers0 = d;
      })
    .transition()
      .duration(2500)
      .attr('d', area);
}

// Inspired by Lee Byron's test data generator.
function bumpLayer(row) {
  return row.map(function(d, i) { return {x: i, y: Math.max(0, d)}; });
}"""
      end

    end
    
  end
  
end
