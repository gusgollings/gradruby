require_relative 'render'
require 'ruby-graphviz'
require 'set'

module DirectedDraw
  def self.trace(root)
    nodes, edges = Set.new, Set.new
    build = -> (vertex) {
      unless nodes.include?(vertex)
        nodes << vertex
        vertex.antecedents.each do |antecedent|
          edges << [antecedent, vertex]
          build.call(antecedent)
        end
      end
    }
    build.call(root)
    return nodes, edges
  end
  
  def self.draw_dot(root)
    dot = GraphViz.new(:G, :rankdir => "LR", :type => :digraph)
  
    nodes, edges = DirectedDraw.trace(root)
  
    nodes.each do |node|
      uid = node.object_id.to_s
      dot.add_nodes(uid, label: "{ %s | data %0.4f | gradient %0.4f }" % [node.label, node.data, node.gradient] , shape: "record")
      if !node.operation.empty?
        operation_name = uid + node.operation
        dot.add_nodes(operation_name, label: node.operation, shape: "circle")
        dot.add_edges(operation_name, uid)
      end
    end
    
    edges.each do |node1, node2|
      origin_name = node1.object_id.to_s
      destination_name = node2.object_id.to_s + node2.operation
      dot.add_edges(origin_name, destination_name)
    end
    
    svg_string = dot.output(:svg => String)
    renderer = Renderer.new  # Uses ConsoleOutput by default
    renderer.render(svg_string)  # Writes to the console
  end
end
