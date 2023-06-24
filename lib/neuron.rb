# frozen_string_literal: true

require_relative 'value'

# The Neuron class represents a single neuron in a neural network.
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
    activation = z.map { |w, x| w * x }.inject(@bias, :+)
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
