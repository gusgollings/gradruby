Gem::Specification.new do |s|
  s.name = "gradruby"
  s.version = "0.0.0"
  s.licenses = ['MIT']
  s.summary = "A scalar-valued autograd engine with a PyTorch-like neural network library."
  s.long_description = "*gradruby* is modelled after Andrej Karpathy's [micrograd](https://github.com/karpathy/micrograd). Its primary purpose is learning aid for simple neural network."
  s.authors = ["Gus Gollings"]
  s.email = "gus.gollings@gmail.com"
  s.files = Dir.glob(lib/*.rb)
  s.files += %w[gradruby.gemspec README.md]
  s.homepage = "http://rubygems.com/gems/gradruby"
  s.required_ruby_version = '>= 3.0.0'
end
