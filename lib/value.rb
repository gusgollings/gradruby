require 'set'

class Value
  attr_accessor :label, :gradient, :data, :_backward
  attr_reader :antecedents, :operation

  def initialize(data, antecedents: [], operation: '', label: "")
    @data = data
    @antecedents = Set.new(antecedents)
    @operation = operation
    @label = label
    @_backward = -> {}
    
    @gradient = 0.0
  end

  def +(addend) 
    addend = addend.is_a?(Value) ? addend : Value.new(addend)
    sum = @data + addend.data
    addends = [self, addend]
    out = Value.new(sum, antecedents: addends, operation: '+')
    
    _backward = -> {
      @gradient += 1.0 * out.gradient
      addend.gradient += 1.0 * out.gradient
    }
    out._backward = _backward

    return out
  end
 
  def *(multiplier)
    multiplier = multiplier.is_a?(Value) ? multiplier : Value.new(multiplier)
    product = @data * multiplier.data
    multiplicands = [self, multiplier]
    out = Value.new(product, antecedents: multiplicands, operation: "*")

    _backward = -> {
      @gradient += multiplier.data * out.gradient
      multiplier.gradient += @data * out.gradient
    }
    out._backward = _backward

    return out
  end
  
  def -@
    self * -1
  end

  def -(subtrahend)
    self + (-subtrahend)
  end
  
  def /(divisor)
    self * divisor**-1
  end
  
  def **(exponent)
    raise "Only supporting int/float powers" unless exponent.is_a?(Float) || exponent.is_a?(Integer)
    out = Value.new(@data**exponent, antecedents: [self], operation: "**#{exponent}")

    _backward = -> {
      @gradient += exponent * (@data ** (exponent - 1)) * out.gradient
    }
    out._backward = _backward

    return out
  end
  
  def exp
    out = Value.new(Math.exp(@data), antecedents: [self], operation: "exp")

    _backward = -> {
      @gradient += out.data * out.gradient
    }
    out._backward = _backward

    return out 
  end
  
  # used for our nonlinearity, could also be `relu`, sigmoid 
  def tanh
    activation = (Math.exp(2 * @data) - 1) / (Math.exp(2 * @data) + 1)
    out = Value.new(activation, antecedents: [self], operation: "tanh")

    _backward = -> {
      @gradient += (1 - activation**2) * out.gradient
    }
    out._backward = _backward

    return out
  end

  def backward
    topological_order = []
    visited = Set.new
    build_topological_order = ->(vertex) {
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
      node._backward.call
    end
  end

private
  def coerce(other)
    [self, other]
  end

  def to_s
    %[Value: #{@data}]
  end
end
