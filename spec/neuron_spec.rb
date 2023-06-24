# frozen_string_literal: true

require 'rspec'
require_relative '../lib/neuron'

describe Neuron do
  let(:neuron) { Neuron.new(3) }
  let(:inputs) { [0.5, 0.6, 0.7] }

  describe '#initialize' do
    it 'initializes with the correct number of weights' do
      expect(neuron.weights.size).to eq(3)
    end
  end

  describe '#call' do
    it 'returns a Value object' do
      expect(neuron.call(inputs)).to be_a(Value)
    end
  end
end
