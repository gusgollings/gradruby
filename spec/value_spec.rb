# frozen_string_literal: true

require 'rspec'
require_relative '../lib/value'

describe Value do
  let(:value1) { Value.new(2) }
  let(:value2) { Value.new(3) }

  describe '#initialize' do
    it 'initializes with the correct data' do
      expect(value1.data).to eq(2)
    end

    it 'initializes with the correct gradient' do
      expect(value1.gradient).to eq(0.0)
    end
  end

  describe '#+' do
    it 'adds two Value objects correctly' do
      sum = value1 + value2
      expect(sum.data).to eq(5)
    end
  end

  describe '#*' do
    it 'multiplies two Value objects correctly' do
      product = value1 * value2
      expect(product.data).to eq(6)
    end
  end

  describe '#-@' do
    it 'negates a Value object correctly' do
      negation = -value1
      expect(negation.data).to eq(-2)
    end
  end

  describe '#-' do
    it 'subtracts two Value objects correctly' do
      difference = value1 - value2
      expect(difference.data).to eq(-1)
    end
  end

  describe '#/' do
    it 'divides two Value objects correctly' do
      quotient = value1 / value2
      expect(quotient.data).to be_within(0.01).of(0.67)
    end
  end

  describe '#**' do
    it 'raises a Value object to a power correctly' do
      power = value1**2
      expect(power.data).to eq(4)
    end
  end

  describe '#exp' do
    it 'calculates the exponential of a Value object correctly' do
      exponential = value1.exp
      expect(exponential.data).to be_within(0.01).of(7.39)
    end
  end

  describe '#tanh' do
    it 'calculates the hyperbolic tangent of a Value object correctly' do
      hyperbolic_tangent = value1.tanh
      expect(hyperbolic_tangent.data).to be_within(0.01).of(0.96)
    end
  end

  describe '#backward' do
    it 'calculates the gradient correctly after a backward pass' do
      sum = value1 + value2
      sum.backward
      expect(value1.gradient).to eq(1.0)
      expect(value2.gradient).to eq(1.0)
    end
  end
end
