# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'gradruby'
  s.version = '0.0.0'
  s.licenses = ['MIT']
  s.summary = 'A scalar-valued autograd engine with a PyTorch-like neural network library.'
  s.long_description = <<-DESC
    *gradruby* is modelled after Andrej Karpathy's#{' '}
    [micrograd](https://github.com/karpathy/micrograd).#{' '}
    Its primary purpose is learning aid for simple neural network.
  DESC
  s.authors = ['Gus Gollings']
  s.email = 'gus.gollings@gmail.com'
  s.files = Dir.glob('lib/*.rb')
  s.files += Dir.glob('helpers/*.rb')
  s.files += %w[gradruby.gemspec README.md]
  s.homepage = 'http://rubygems.com/gems/gradruby'
  s.required_ruby_version = '>= 3.2.0'
  s.add_dependency 'ruby-graphviz'
  s.add_dependency 'nyaplot'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rubocop'
end
