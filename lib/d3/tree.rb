class Tree

  attr_accessor :element, :children

  def initialize element, children = []
    @element, @children = element, children
  end

  def add_node(name, value)
    @children << {name: name, value: value}
  end

  def add_tree(name)
    t = Tree.new name
    @children << t
    t
  end

  def each &pr
    pr.call(@element)
    @children.each{|x| x.each(&pr)}
    self
  end

  def to_hash
    c = @children.map{|e|
      if(e.instance_of? Tree or e.instance_of? Node)
        e.to_hash
      else
        e
      end
    }
    h = {
      :name => @element,
      :children => c
    }
  end

end

