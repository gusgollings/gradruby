# frozen_string_literal: true

require_relative 'neuron'

# The Layer class represents a layer of neurons in a neural network.
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
    @neurons.flat_map(&:parameters)
  end

  private

  def validate_inputs(inputs)
    inputs.each do |input|
      unless input.is_a?(Float) || input.is_a?(Value)
        raise "Layer Invalid input: #{input.class} ||| #{input.send(:inspect)}"
      end
    end
  end
end
