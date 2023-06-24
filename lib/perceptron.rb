# frozen_string_literal: true

require_relative 'layer'

# The Perceptron class represents a simple type of neural network.
class Perceptron
  attr_reader :layers

  def initialize(neuron_inputs, neuron_outputs)
    sizes = [neuron_inputs] + neuron_outputs
    @layers = neuron_outputs.map.with_index do |_, index|
      Layer.new(sizes[index], sizes[index + 1])
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
      raise "MLP Invalid input: #{input}" unless input.is_a?(Float)
    end
  end
end
