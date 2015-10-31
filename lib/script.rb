require "#{File.dirname(__FILE__)}/script/base"
require "#{File.dirname(__FILE__)}/script/pie"
require "#{File.dirname(__FILE__)}/script/circle_packing"
require "#{File.dirname(__FILE__)}/script/treemap_padding"
require "#{File.dirname(__FILE__)}/script/cluster_dendogram"
require "#{File.dirname(__FILE__)}/script/sunburst"
require "#{File.dirname(__FILE__)}/script/streamgraph"

module Client

  # See https://github.com/mbostock/d3/wiki/Gallery
  module Script

    include Client::Script::Base
    #include Client::Script::Pie
    include Client::Script::CirclePacking
    include Client::Script::TreemapPadding
    include Client::Script::ClusterDendogram
    include Client::Script::Sunburst
    include Client::Script::Streamgraph

  end

end





