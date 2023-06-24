# frozen_string_literal: true

require 'rspec'
require_relative '../lib/perceptron'

describe Perceptron do
  let(:neuron_inputs) { 3 }
  let(:neuron_outputs) { [2, 1] }
  let(:perceptron) { Perceptron.new(neuron_inputs, neuron_outputs) }
  let(:inputs) { [0.5, 0.6, 0.7] }

  describe '#initialize' do
    it 'initializes with the correct number of layers' do
      expect(perceptron.layers.size).to eq(neuron_outputs.size)
    end
  end

  describe '#call' do
    it 'returns an array of Value objects' do
      expect(perceptron.call(inputs)).to be_a(Value)
    end

    context 'when inputs are not all Floats' do
      let(:invalid_inputs) { [1, 'two', :three] }

      it 'raises an error' do
        expect { perceptron.call(invalid_inputs) }.to raise_error(RuntimeError, /MLP Invalid input/)
      end
    end
  end

  describe '#parameters' do
    it 'returns an array of all parameters from all layers' do
      all_parameters = perceptron.layers.flat_map(&:parameters)
      expect(perceptron.parameters).to eq(all_parameters)
    end
  end
end
