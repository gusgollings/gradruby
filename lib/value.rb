# frozen_string_literal: true

# The Value class represents a value that can be used in computations,
# and can keep track of gradients for automatic differentiation.
class Value
  attr_accessor :label, :gradient, :data, :local_backward
  attr_reader :antecedents, :operation

  def initialize(data, antecedents: [], operation: '', label: '')
    @data = data
    @antecedents = Set.new(antecedents)
    @operation = operation
    @label = label
    @local_backward = -> {}

    @gradient = 0.0
  end

  def +(other)
    other = other.is_a?(Value) ? other : Value.new(other)
    sum = @data + other.data
    addends = [self, other]
    out = Value.new(sum, antecedents: addends, operation: '+')

    local_backward = lambda {
      @gradient += 1.0 * out.gradient
      other.gradient += 1.0 * out.gradient
    }
    out.local_backward = local_backward

    out
  end

  def *(other)
    other = other.is_a?(Value) ? other : Value.new(other)
    product = @data * other.data
    multiplicands = [self, other]
    out = Value.new(product, antecedents: multiplicands, operation: '*')

    local_backward = lambda {
      @gradient += other.data * out.gradient
      other.gradient += @data * out.gradient
    }
    out.local_backward = local_backward

    out
  end

  def -@
    self * -1
  end

  def -(other)
    self + -other
  end

  def /(other)
    self * other**-1
  end

  def **(other)
    raise 'Only supporting int/float powers' unless other.is_a?(Float) || other.is_a?(Integer)

    out = Value.new(@data**other, antecedents: [self], operation: "**#{other}")

    local_backward = lambda {
      @gradient += other * (@data**(other - 1)) * out.gradient
    }
    out.local_backward = local_backward

    out
  end

  def exp
    out = Value.new(Math.exp(@data), antecedents: [self], operation: 'exp')

    local_backward = lambda {
      @gradient += out.data * out.gradient
    }
    out.local_backward = local_backward

    out
  end

  # used for our nonlinearity, could also be `relu`, sigmoid
  def tanh
    activation = (Math.exp(2 * @data) - 1) / (Math.exp(2 * @data) + 1)
    out = Value.new(activation, antecedents: [self], operation: 'tanh')

    local_backward = lambda {
      @gradient += (1 - activation**2) * out.gradient
    }
    out.local_backward = local_backward

    out
  end

  def backward
    topological_order = []
    visited = Set.new
    build_topological_order = lambda { |vertex|
      unless visited.include? vertex
        visited << vertex
        vertex.antecedents.each do |antecedent|
          build_topological_order.call(antecedent)
        end
        topological_order << vertex
      end
    }
    build_topological_order.call(self)

    @gradient = 1.0

    topological_order.reverse.each do |node|
      node.local_backward.call
    end
  end

  private

  def coerce(other)
    [self, other]
  end

  def to_s
    %(Value: #{@data})
  end
end
