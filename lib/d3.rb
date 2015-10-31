require "#{File.dirname(__FILE__)}/d3/base"
require "#{File.dirname(__FILE__)}/d3/json"
require "#{File.dirname(__FILE__)}/d3/histogram"
require "#{File.dirname(__FILE__)}/d3/treemap"

module D3

  include D3::Base
  include D3::Histogram
  include D3::JSON
  include D3::Treemap

end
