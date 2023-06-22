require_relative "value.rb"

class Neuron
  attr_reader :weights
  def initialize(neuron_inputs)
    @weights = Array.new(neuron_inputs) { Value.new(rand(-1.0..1.0)) }
    @bias = Value.new(rand(-1..1))
  end

  def call(inputs)
    validate_inputs(inputs)
    validate_inputs(@weights)
    z = @weights.zip(inputs)
    activation = z.map {|w, x| w * x }.inject(@bias, :+)
    activation.tanh
  end

  def parameters
    @weights + [@bias]
  end

private
  def validate_inputs(inputs)
    inputs.each do |input|
      raise "Neuron Invalid input: #{input.send(:inspect)}" unless input.is_a?(Float) || input.is_a?(Value)
    end
  end

  def inspect
    "#Neuron: #{@weights}"
  end
end

class Layer
  attr_reader :neurons
  def initialize(neuron_inputs, neuron_output)
    @neurons = Array.new(neuron_output) { Neuron.new(neuron_inputs) }
  end

  def call(inputs)
    validate_inputs(inputs)
    outs = @neurons.map { |neuron| neuron.call(inputs) }
    outs.length == 1 ? outs.shift : outs
  end

  def parameters
    parameters = []
    @neurons.each do |neuron|
      neuron.parameters.each { |parameter| parameters << parameter }
    end
    parameters
  end

private
  def validate_inputs(inputs)
    inputs.each do |input|
      raise "Layer Invalid input: #{input.class} ||| #{input.send(:inspect)}" unless input.is_a?(Float) || input.is_a?(Value)
    end
  end
end

class MLP
  attr_reader :layers
  def initialize(neuron_inputs, neuron_outputs)
    sizes = [neuron_inputs] + neuron_outputs
    @layers = neuron_outputs.map.with_index do |_, index|
      Layer.new(sizes[index], sizes[index+1])
    end
  end

  def call(inputs)
    validate_inputs(inputs)
    @layers.each do |layer|
      inputs = layer.call(inputs)
    end
    inputs
  end

  def parameters
    parameters = []
    @layers.each do |layer|
      layer.parameters.each { |parameter| parameters << parameter }
    end
    parameters
  end

private
  def validate_inputs(inputs)
    inputs.each do |input|
      raise "MLP Invalid input: #{input.to_s}" unless input.is_a?(Float)
    end
  end
end 

