# frozen_string_literal: true

require 'rspec'
require_relative '../lib/layer'

describe Layer do
  let(:neuron_inputs) { 3 }
  let(:neuron_output) { 2 }
  let(:layer) { Layer.new(neuron_inputs, neuron_output) }
  let(:inputs) { [0.5, 0.6, 0.7] }

  describe '#initialize' do
    it 'initializes with the correct number of neurons' do
      expect(layer.neurons.size).to eq(neuron_output)
    end
  end

  describe '#call' do
    it 'returns an array of Value objects' do
      expect(layer.call(inputs)).to all(be_a(Value))
    end

    context 'when inputs are not all Floats or Values' do
      let(:invalid_inputs) { [1, 'two', :three] }

      it 'raises an error' do
        expect { layer.call(invalid_inputs) }.to raise_error(RuntimeError, /Layer Invalid input/)
      end
    end
  end

  describe '#parameters' do
    it 'returns an array of all parameters from all neurons' do
      all_parameters = layer.neurons.flat_map(&:parameters)
      expect(layer.parameters).to eq(all_parameters)
    end
  end
end
