# frozen_string_literal: true

require 'ruby-graphviz'
require_relative 'renderer'

# draws directed graphs to SVG
module DirectedDraw
  def self.trace(root)
    nodes = Set.new
    edges = Set.new
    build = lambda { |vertex|
      unless nodes.include?(vertex)
        nodes << vertex
        vertex.antecedents.each do |antecedent|
          edges << [antecedent, vertex]
          build.call(antecedent)
        end
      end
    }
    build.call(root)
    [nodes, edges]
  end

  def self.draw_dot(root)
    dot = GraphViz.new(:G, rankdir: 'LR', type: :digraph)

    nodes, edges = DirectedDraw.trace(root)

    nodes.each do |node|
      uid = node.object_id.to_s
      dot.add_nodes(uid, label: format('{ %<label>s | data %<data>0.4f | gradient %<gradient>0.4f }',
                                       label: node.label, data: node.data, gradient: node.gradient), shape: 'record')
      next if node.operation.empty?

      operation_name = uid + node.operation
      dot.add_nodes(operation_name, label: node.operation, shape: 'circle')
      dot.add_edges(operation_name, uid)
    end

    edges.each do |node1, node2|
      origin_name = node1.object_id.to_s
      destination_name = node2.object_id.to_s + node2.operation
      dot.add_edges(origin_name, destination_name)
    end

    svg_string = dot.output(svg: String)
    renderer = Renderer.new # Uses ConsoleOutput by default
    renderer.render(svg_string) # Writes to the console
  end
end
